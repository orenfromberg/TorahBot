#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

pushd mongo || exit
if ! [ -f dump_small.tar.gz ]; then
    wget https://storage.googleapis.com/sefaria-mongo-backup/dump_small.tar.gz
fi
popd || exit
docker compose -f docker-compose.yml -f docker-compose.bootstrap.yml up mongo -d --wait --build
docker compose exec mongo bash -c "mongorestore --drop /tmp/dump && rm -rf /tmp/dump"
docker compose stop mongo