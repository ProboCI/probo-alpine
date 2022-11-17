#!/bin/bash

echo "---------------------------------------------------------------"
printf "Alpine - PHP 8.1 ProboCI Build: "
docker build . -q -t docker.flyingflip.com/probo/alpine:php8.1 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  printf "Pushing to FlyingFlip: "
  docker push -q docker.flyingflip.com/probo/alpine:php8.1
fi

echo "---------------------------------------------------------------"
