#!/usr/bin/env bash


sudo su
mkdir -p /steps
touch /steps/step001
sudo apt update

sudo rm -rf /root/.ssh/authorized_keys
sudo cp  /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
sudo touch /steps/step002

export USE_HOSTNAME=${serverhostname}
sudo echo $USE_HOSTNAME > /etc/hostname
sudo hostname -F /etc/hostname

sudo hostnamectl set-hostname $USE_HOSTNAME
sudo touch /steps/step003

sudo apt -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
touch /steps/step004

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
touch /steps/step005

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
touch /steps/step006


sudo apt install -y git wget curl nano tmux rpl nfs-common
touch /steps/step007


echo ${DOCKER_LOGIN_ACCESS_TOKEN} | docker login --username ${DOCKER_LOGIN_USERNAME} --password-stdin
touch /steps/step008



sudo mkdir -p /docker_swarm_config
cd /docker_swarm_config

pushd /docker_swarm_config
    sudo docker swarm leave --force
    sudo docker swarm init | grep -E "docker swarm join --token SW" > /docker_swarm_config/swarm_token.txt
    sudo rpl -v "\n" "" swarm_token.txt
    sudo rpl -v "    " "" swarm_token.txt
    sudo docker swarm join-token manager | grep -E "docker swarm join --token SW" > /docker_swarm_config/swarm_token_manager.txt
    sudo rpl -v "\n" "" /docker_swarm_config/swarm_token_manager.txt
    sudo rpl -v "    " "" /docker_swarm_config/swarm_token_manager.txt
popd > /dev/null
touch /steps/step009


echo -e "StrictHostKeyChecking no\n" >> /root/.ssh/config

cat >  /root/.ssh/id_rsa << EOL
${PRIVATE_SSH_KEY}
EOL

chmod 600  /root/.ssh/id_rsa
ssh-keygen -f /root/.ssh/id_rsa -y > /root/.ssh/id_rsa.pub
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
touch /steps/step010

mkdir -p /github/ycit021
pushd /github/ycit021
    git clone git@github.com:YCIT-W23-021-DevOps-Practices-And-Tools/Host-Fullstack-app-in-AWS-using-Docker-Swarm.git
popd > /dev/null
touch /steps/step011


pushd /github/ycit021/Host-Fullstack-app-in-AWS-using-Docker-Swarm/infrastructure/Swarm-manger
    docker network create --driver=overlay traefik-public
    export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

    docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID
    export EMAIL=${domain-owner-email}

    export DOMAIN=traefik.${domain-name}

    export USERNAME=${domain-owner-email}

    export PASSWORD=${swarm-master-password}
    export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
    docker stack deploy -c traefik-host.yml traefik &&  touch /steps/step012-1

    export DOMAIN=swarmpit.${domain-name}

    export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

    docker node update --label-add swarmpit.db-data=true $NODE_ID

    docker node update --label-add swarmpit.influx-data=true $NODE_ID

    docker stack deploy -c swarmpit.yml swarmpit &&  touch /steps/step012-2

    echo "127.0.0.1 $DOMAIN" >> /etc/hosts
    echo "" >> /etc/hosts

    sleep 100


    curl --insecure -X POST -H 'Content-Type: application/json' \
         https://$DOMAIN/initialize -d  '{"username": "${domain-owner-email}", "password": "${swarm-master-password}"}' && \
          touch /steps/step012-3

     export ADMIN_USER=${domain-owner-email}

    export ADMIN_PASSWORD=${swarm-master-password}

    export HASHED_PASSWORD=$(openssl passwd -apr1 $ADMIN_PASSWORD)

    export DOMAIN=${domain-name}

    export SLACK_URL=${SLACK_URL}
    export SLACK_CHANNEL=${SLACK_CHANNEL}
    export SLACK_USER=${SLACK_USER}

    git clone https://github.com/stefanprodan/swarmprom.git

    cp swarmprom.yml swarmprom/swarmprom.yml
    pushd /github/ycit021/Host-Fullstack-app-in-AWS-using-Docker-Swarm/infrastructure/Swarm-manger/swarmprom
        docker stack deploy -c swarmprom.yml swarmprom &&  touch /steps/step012-4
    popd > /dev/null


popd > /dev/null
touch /steps/step012
