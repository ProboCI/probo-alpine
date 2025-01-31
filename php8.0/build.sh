#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.0 ProboCI Build: "
echo "---------------------------------------------------------------"
docker buildx build --platform linux/amd64,linux/arm64 -t proboci/alpine:php8.0 --push .
