COMPOSE_DOCKER_CLI_BUILD=1

## .env.test

# Admin Jenkins
JENKINS_ADMIN_ID=admin
JENKINS_ADMIN_PASSWORD=admin
JENKINS_URL=http://localhost:8080/
ADMIN_EMAIL=replace@replace


# DOCKER_GID=997   # (ex sur Debian; mieux: calcule-le)

# GitHub (au choix PAT ou App)
GITHUB_USER=replace
GITHUB_PAT=replace
GITHUB_CLIENT_SECRET=replace
GITHUB_CLIENT_ID=replace

# DockerHub (si utilisé)
DOCKERHUB_USER=replace
DOCKERHUB_PAT=replace

# SonarQube (si utilisé)
SONAR_TOKEN=replace
SONAR_URL=https://sonarcloud.io

# eMail (si notifications par email)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USE_SSL=false
SMTP_USE_TLS=true
SMTP_USER=replace@gmail.com
SMTP_PASS=replace

#SLACK_BOT_TOKEN=replace
#SLACK_TEAM_ID=replace

# Users for demo (dev and students)
DEVUSER1_PASS=devuser1
DEVUSER2_PASS=devuser2
STUDENT1_PASS=student1
STUDENT2_PASS=student2
BILONJEA_PASS=bilonjea


# Jenkins Agents ssh (si utilisés)
AGENT_SSH_PORT=2222

 #host.docker.internal
IP_DU_HOST_AGENT=host.docker.internal    





## Commande docker
```
docker network create jenkins-net
docker network ls
docker compose --env-file .env.prd up -d --build
docker compose logs --no-log-prefix jenkins | tail -n 200
docker compose logs -f jenkins

docker exec -it jenkins bash
docker exec -u 0 -it jenkins bash


docker compose --env-file .env up -d --force-recreate jenkins
docker rm --force $(docker ps -a -q)

docker compose down
docker volume ls | grep jenkins-101_jenkins_home
docker volume rm jenkins-101_jenkins_home   # supprime le volume nommé
sudo ls -la /var/lib/docker/volumes/jenkins-101_jenkins_home/_data

docker system prune -a --volumes
docker image prune -a
docker volume prune
```

## YouTube Link
For the full 1 hour course watch on youtube:
https://www.youtube.com/watch?v=6YZvp2GwT0A

# Installation
## Build the Jenkins BlueOcean Docker Image (or pull and use the one I built)
```
docker build -t myjenkins-blueocean:2.414.2 .

#IF you are having problems building the image yourself, you can pull from my registry (It is version 2.332.3-1 though, the original from the video)

docker pull devopsjourney1/jenkins-blueocean:2.332.3-1 && docker tag devopsjourney1/jenkins-blueocean:2.332.3-1 myjenkins-blueocean:2.332.3-1
```

## Create the network 'jenkins'
```
docker network create jenkins
```

## Run the Container
### MacOS / Linux
```
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.414.2
```

### Windows
```
docker run --name jenkins-blueocean --restart=on-failure --detach `
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 `
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 `
  --volume jenkins-data:/var/jenkins_home `
  --volume jenkins-docker-certs:/certs/client:ro `
  --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.414.2
```


## Get the Password
```
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

## Connect to the Jenkins
```
https://localhost:8080/
```

## Installation Reference:
https://www.jenkins.io/doc/book/installing/docker/


## alpine/socat container to forward traffic from Jenkins to Docker Desktop on Host Machine

https://stackoverflow.com/questions/47709208/how-to-find-docker-host-uri-to-be-used-in-jenkins-docker-plugin
```
docker run -d --restart=always -p 127.0.0.1:2376:2375 --network jenkins -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
docker inspect <container_id> | grep IPAddress
```

## Using my Jenkins Python Agent
```
docker pull devopsjourney1/myjenkinsagents:python
```
## Build & push agent 

# CI neutre
```
docker build -t registry.example.com/ci-toolbox:latest ./ci-toolbox
docker push registry.example.com/ci-toolbox:latest
```
registry.example.com can be change by the  placeholder of your images registry (ex: GitLab Registry, GHCR, ECR…)

You can see here [`build-docker-images.bash`](./build-docker-images.bash) where i push my images agents in my hub.docker.com


## 🔁 Maintenance Jenkins (reset & restore)

Scripts :
- [`reset-jenkins.sh`](./scripts/reset-jenkins.sh) — sauvegarde `jenkins-data` ➜ recrée un **home propre** ➜ rebuild & restart
- [`restore-jenkins.sh`](./scripts/restore-jenkins.sh) — restaure un backup `jenkins_home_backup_*.tgz` dans `jenkins-data`

### Prérequis
- Docker + Docker Compose (v2 ou v1)
- Les scripts sont exécutables :
  ```bash
  chmod +x ./scripts/reset-jenkins.sh ./scripts/restore-jenkins.sh


# Rendre les scripts exécutables et enregistrer le bit exec dans Git
chmod +x scripts/reset-jenkins.sh scripts/restore-jenkins.sh
git update-index --chmod=+x scripts/reset-jenkins.sh scripts/restore-jenkins.sh

# Après ajout de .gitattributes, normaliser les fins de ligne (une fois)
git rm --cached -r .
git add .
git commit -m "Normalize line endings per .gitattributes"





