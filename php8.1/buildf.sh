#!/bin/bash

# docker build . -t docker.flyingflip.com/probo/alpine:php8.1

echo "---------------------------------------------------------------"
echo -n "Alpine - PHP 8.1 ProboCI Build: "
docker build . -q -t docker.flyingflip.com/probo/alpine:php8.1
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo -n "Pushing to FlyingFlip: "
  docker push -q docker.flyingflip.com/probo/alpine:php8.1
fi

echo "---------------------------------------------------------------"
