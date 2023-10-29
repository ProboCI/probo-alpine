#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.2 ProboCI Build: \n"
echo "---------------------------------------------------------------"
docker build . -t proboci/alpine:php8.2 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo "---------------------------------------------------------------"
  echo "Pushing to DockerHub: \n"
  docker push proboci/alpine:php8.2
fi
echo "---------------------------------------------------------------"
