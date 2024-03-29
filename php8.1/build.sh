#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.1 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build . -t proboci/alpine:php8.1 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
echo "---------------------------------------------------------------"
  echo "Pushing to DockerHub: "
  docker push proboci/alpine:php8.1
fi
echo "---------------------------------------------------------------"
