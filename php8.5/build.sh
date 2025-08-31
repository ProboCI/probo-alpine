#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.5 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php8.5 . --push
