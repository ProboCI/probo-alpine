#!/bin/bash

echo "---------------------------------------------------------------"
echo -n "Alpine - PHP 7.4 ProboCI Build: "
docker build . -q -t proboci/alpine:php7.4
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo -n "Pushing to DockerHub: "
  docker push -q proboci/alpine:php7.4
fi

echo "---------------------------------------------------------------"
