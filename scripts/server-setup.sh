#!/bin/sh

echo "Installing firewall ..."
apt install ufw -y
ufw allow ssh
ufw allow 22/tcp
ufw enable

echo "Firewall enabled (ssh) ..."

echo "Docker installation started ..."
chmod 777 /home/install-docker.sh
/home/install-docker.sh

echo "running docker containers ..."
docker compose -f /home/setup.yml up -d
