
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





