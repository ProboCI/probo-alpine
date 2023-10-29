#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 8.0 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build . -t proboci/alpine:php8.0 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo "---------------------------------------------------------------"
  echo "Pushing to DockerHub: "
  docker push proboci/alpine:php8.0
fi
echo "---------------------------------------------------------------"
