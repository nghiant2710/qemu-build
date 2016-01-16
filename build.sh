#!/bin/bash

set -o errexit

./configure --target-list="arm-linux-user" --static \
	&& make -j $(nproc) \
	&& strip arm-linux-user/qemu-arm \
	&& mkdir -p qemu-$QEMU_VERSION \
	&& cp arm-linux-user/qemu-arm qemu-$QEMU_VERSION/qemu-arm-static

tar -cvzf qemu-$QEMU_VERSION.tar.gz qemu-$QEMU_VERSION
SHA256=$(sha256sum qemu-$QEMU_VERSION.tar.gz)
echo $SHA256
if [ -z "$ACCOUNT" ] || [ -z "$REPO" ] || [ -z "$ACCESS_TOKEN" ]; then
	echo "Please set value for ACCOUNT, REPO and ACCESS_TOKEN!"
	exit 1
fi

# Create a release
rm -f request.json response.json
cat > request.json <<-EOF
{
    "tag_name": "$QEMU_VERSION",
    "target_commitish": "$sourceBranch",
    "name": "v$QEMU_VERSION",
    "body": "Release of version $QEMU_VERSION.\nSHA256: ${SHA256% *}",
    "draft": false,
    "prerelease": false
}
EOF
curl --data "@request.json" --header "Content-Type:application/json" https://api.github.com/repos/$ACCOUNT/$REPO/releases?access_token=$ACCESS_TOKEN -o response.json
# Parse response
RELEASE_ID=$(cat response.json | ./jq '.id')
echo "RELEASE_ID=$RELEASE_ID"

# Upload data
curl -H "Authorization:token $ACCESS_TOKEN" -H "Content-Type:application/x-gzip" --data-binary "@qemu-$QEMU_VERSION.tar.gz" https://uploads.github.com/repos/$ACCOUNT/$REPO/releases/$RELEASE_ID/assets?name=qemu-$QEMU_VERSION.tar.gz
