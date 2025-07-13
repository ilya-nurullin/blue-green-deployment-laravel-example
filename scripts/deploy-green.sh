#!/bin/bash

function goDockerHome {
    cd /home/deploy/apps/site
}

function goApp {
    cd /home/deploy/apps/site/releases/green
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

function startGreenRelease {
    sudo docker compose up -d green green_nginx
    sleep 15
}

function stopBlueRelease {
    sudo docker compose stop blue blue_nginx
}

goApp
downloadNewCode
buildApp

goDockerHome
startGreenRelease
stopBlueRelease

