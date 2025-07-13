#!/bin/bash

if [ "$(sudo docker ps -q -f name=blue)" ]; then
    echo "Container 'blue' is running."
    bash ./deploy-green.sh
else
    echo "Container 'blue' is not running."
    bash ./deploy-blue.sh
fi

