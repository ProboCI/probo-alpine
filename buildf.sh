#!/bin/bash

cd ./php7.4/
sh ./buildf.sh $1

cd ../php8.0/
sh ./buildf.sh $1

cd ../php8.1/
sh ./buildf.sh $1
