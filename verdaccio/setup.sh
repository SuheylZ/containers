#!/bin/bash
# This script sets up Verdaccio, a lightweight private npm proxy registry.

sudo mkdir -p /var/data/verdaccio && sudo chown -R $USER /var/data/verdaccio && sudo chmod -R 777 /var/data/verdaccio

sudo mkdir -p /var/data/verdaccio/storage && sudo chown -R $USER /var/data/verdaccio/storage && \
sudo chmod -R 777 /var/data/verdaccio/storage

cp ./config.yaml /var/data/verdaccio/config.yaml

docker run --rm -v /var/data/verdaccio/conf:/conf httpd:2.4 htpasswd -B -c /conf/htpasswd admin '_![N(45RD6*f'


