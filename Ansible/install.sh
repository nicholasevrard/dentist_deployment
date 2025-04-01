#!/bin/bash

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker >

if ! docker version &> /dev/null && ! docker compose version &> /dev/null; then
  sudo apt-get install -y ca-certificates curl zip
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyr>
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.>
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-p>
  sudo chmod 777 /var/run/docker.sock
  sudo usermod -aG docker $USER
fi

docker compose up -d

docker ps
