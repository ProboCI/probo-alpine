#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.2 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.2 . --push
