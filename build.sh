#!/bin/bash

docker build -t qemu .
docker run -v `pwd`/bin:/output qemu
