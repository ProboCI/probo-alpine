#!/bin/bash

cd ./php7.4/
./build.sh $1 $2

cd ../php8.0/
./build.sh $1 $2

cd ../php8.1/
./build.sh $1 $2

cd ../php8.2/
./build.sh $1 $2

cd ../php8.3/
./build.sh $1 $2

cd ../php8.4
./build.sh $1 $2

cd ..

