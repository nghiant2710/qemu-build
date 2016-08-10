#!/bin/bash

docker build -t qemu-builder .

docker run --rm -e ACCOUNT=$ACCOUNT \
				-e REPO=$REPO \
				-e ACCESS_TOKEN=$ACCESS_TOKEN \
				-e TARGET=$TARGET \
				-e sourceBranch=$sourceBranch qemu-builder 
