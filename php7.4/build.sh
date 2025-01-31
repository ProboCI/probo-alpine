#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 7.4 ProboCI Build: "
echo "---------------------------------------------------------------"
docker buildx build --platform linux/amd64,linux/arm64 -t proboci/alpine:php7.4 --push .
