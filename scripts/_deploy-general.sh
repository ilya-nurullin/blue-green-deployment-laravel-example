#!/bin/bash

if [ -z "$CURRENT" ]; then
    echo "Please set CURRENT variable"
    exit 1
fi

if [ -z "$PREV" ]; then
    echo "Please set PREV variable"
    exit 1
fi

function goDockerHome {
    cd /home/deploy/apps/site
}

function goApp {
    cd /home/deploy/apps/site/releases/$CURRENT
}

function downloadNewCode {
    git fetch origin prod
    git checkout prod
    git reset --hard origin/prod
}

function buildApp {
    composer install
    /home/deploy/.bun/bin/bun install
    /home/deploy/.bun/bin/bun run build
}

function optimizeResources {
	sudo docker exec -it $CURRENT php artisan optimize:clear
	sudo docker exec -it $CURRENT php artisan optimize
}

function startCurrentRelease {
    sudo docker compose up -d $CURRENT ${CURRENT}_nginx
    optimizeResources
    sleep 10
	sudo docker exec -it gateway sh -c "echo \"set server blue_green/${CURRENT} state ready\" | socat stdio unix-connect:/sock/admin.sock"
}

function stopPrevRelease {
	sudo docker exec -it gateway sh -c "echo \"set server blue_green/${PREV} state maint\" | socat stdio unix-connect:/sock/admin.sock"
	sleep 10
    sudo docker compose stop $PREV ${PREV}_nginx
}

goApp
downloadNewCode
buildApp

goDockerHome
startCurrentRelease
stopPrevRelease

