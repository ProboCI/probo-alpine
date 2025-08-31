#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.1 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.1 . --push
