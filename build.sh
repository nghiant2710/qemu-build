#!/bin/bash

set -o errexit


BINARY_NAME="qemu-$TARGET-static"
PACKAGE_NAME="qemu-$QEMU_VERSION-$TARGET"

./configure --target-list="$TARGET-linux-user" --static \
	&& make -j $(nproc) \
	&& strip "$TARGET-linux-user/qemu-$TARGET" \
	&& mkdir -p "$PACKAGE_NAME" \
	&& cp "$TARGET-linux-user/qemu-$TARGET" "$PACKAGE_NAME/$BINARY_NAME"

tar -cvzf "$PACKAGE_NAME.tar.gz" "$PACKAGE_NAME"
SHA256=$(sha256sum "$PACKAGE_NAME.tar.gz")
echo $SHA256
if [ -z "$ACCOUNT" ] || [ -z "$REPO" ] || [ -z "$ACCESS_TOKEN" ]; then
	echo "Please set value for ACCOUNT, REPO and ACCESS_TOKEN!"
	exit 1
fi

# Create a release
rm -f request.json response.json
cat > request.json <<-EOF
{
    "tag_name": "$PACKAGE_NAME",
    "target_commitish": "$sourceBranch",
    "name": "v$QEMU_VERSION",
    "body": "Release of version $PACKAGE_NAME.\nSHA256: ${SHA256% *}",
    "draft": false,
    "prerelease": false
}
EOF
curl --data "@request.json" --header "Content-Type:application/json" https://api.github.com/repos/$ACCOUNT/$REPO/releases?access_token=$ACCESS_TOKEN -o response.json
# Parse response
RELEASE_ID=$(cat response.json | ./jq '.id')
echo "RELEASE_ID=$RELEASE_ID"

# Upload data
curl -H "Authorization:token $ACCESS_TOKEN" -H "Content-Type:application/x-gzip" --data-binary "@$PACKAGE_NAME.tar.gz" https://uploads.github.com/repos/$ACCOUNT/$REPO/releases/$RELEASE_ID/assets?name=$PACKAGE_NAME.tar.gz
