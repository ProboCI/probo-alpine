#!/bin/bash

cd ./php7.4/
./buildf.sh $1

cd ../php8.0/
./buildf.sh $1

cd ../php8.1/
./buildf.sh $1
