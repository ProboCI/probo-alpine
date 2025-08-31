#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.4 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.4 . --push
