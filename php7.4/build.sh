#!/bin/bash

echo "---------------------------------------------------------------"
echo "Alpine - PHP 7.4 ProboCI Build: "
echo "---------------------------------------------------------------"
docker build . -t proboci/alpine:php7.4 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo "---------------------------------------------------------------"
  echo "Pushing to DockerHub: "
  docker push proboci/alpine:php7.4
fi
echo "---------------------------------------------------------------"
