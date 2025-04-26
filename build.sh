#!/bin/bash

# docker might create the bind mount as root:root if you let it, which is annoying for local development. Create it here under you own user if it doesn't already exist.
if [ ! -e './tastyigniter' ]; then
    mkdir ./tastyigniter
fi

docker compose up --build
