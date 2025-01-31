#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.4 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker buildx build --platform linux/amd64,linux/arm64 -t proboci/alpine:php8.4 --push .
