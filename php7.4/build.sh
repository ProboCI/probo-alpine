#!/bin/bash

echo "---------------------------------------------------------------"
printf "Alpine - PHP 7.4 ProboCI Build: "
docker build . -q -t proboci/alpine:php7.4 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  printf "Pushing to DockerHub: "
  docker push -q proboci/alpine:php7.4
fi

echo "---------------------------------------------------------------"
