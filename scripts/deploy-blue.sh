#!/bin/bash

function goDockerHome {
    cd /home/deploy/apps/site
}

function goApp {
    cd /home/deploy/apps/site/releases/blue
}

function downloadNewCode {
    git fetch origin prod
    git checkout prod
    git reset --hard origin/prod
}

function buildApp {
    composer install
    bun install
    bun run build
}

function startBlueRelease {
    sudo docker compose up -d blue blue_nginx
    sleep 15
}

function stopGreenRelease {
    sudo docker compose stop green green_nginx
}

goApp
downloadNewCode
buildApp

goDockerHome
startBlueRelease
stopGreenRelease

