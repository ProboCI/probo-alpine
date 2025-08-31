#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.3 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.3 . --push
