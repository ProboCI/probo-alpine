#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 7.4 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build -t proboci/alpine:php7.4 . --push