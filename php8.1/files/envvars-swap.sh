#!/bin/bash

envsubst < "/etc/apache2/conf.d/envvars.conf" | sponge "/etc/apache2/conf.d/envvars.conf"
