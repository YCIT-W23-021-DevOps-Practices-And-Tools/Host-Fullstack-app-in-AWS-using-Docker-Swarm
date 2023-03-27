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



echo -e "StrictHostKeyChecking no\n" >> /root/.ssh/config

cat >  /root/.ssh/id_rsa << EOL
${PRIVATE_SSH_KEY}
EOL

chmod 600  /root/.ssh/id_rsa
ssh-keygen -f /root/.ssh/id_rsa -y > /root/.ssh/id_rsa.pub
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
touch /steps/step010

mkdir /docker_swarm_config

rsync -chavzP --stats root@swarm-manager.private.codevteacher.com:/docker_swarm_config/ /docker_swarm_config/

cd /docker_swarm_config

bash swarm_token.txt
