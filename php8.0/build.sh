#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.0 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.0 . --push
