#!/bin/bash

cd ./php7.4/
./build.sh $1

cd ../php8.0/
./build.sh $1

cd ../php8.1/
./build.sh $1
