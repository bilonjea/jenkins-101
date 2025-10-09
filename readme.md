# Commandes docker utils

## create network jenkins-net
```
docker network create jenkins-net
docker network ls (check)
```

## build image et run docker pour le controlleur jenkins
```
docker compose --env-file .env.test up -d --build               # appliquer la racine du fichier docker-compose.yml
```

## voir les logs 
```
docker compose logs --no-log-prefix jenkins | tail -n 200       # appliquer la racine du fichier docker-compose.yml
docker compose logs -f jenkins                                  # appliquer la racine du fichier docker-compose.yml
```

## se longuer dans son docker 
```
docker exec -it jenkins bash
```

## se longuer dans son docker en admin
```
docker exec -u 0 -it jenkins bash 
```

## Arrête de l'instance docker
```
docker compose down                                             # appliquer la racine du fichier docker-compose.yml
docker stop mondocker
```

## relance d une instance docker existante
```
docker compose up -d                                             # appliquer la racine du fichier docker-compose.yml
docker start mondocker
```

# Commandes docker utils pour clean

## Attention supprime toutes ses instances docker
```
docker rm --force $(docker ps -a -q)
```

## Suppression des images
```
docker image prune -a
```

## Suppression des volumes
```
docker system prune -a --volumes
docker volume prune
```

## Suppression d'un volume spécifique
```
docker volume ls | grep jenkins-101_jenkins_home
docker volume rm jenkins-101_jenkins_home          # supprime le volume nommé
sudo ls -la /var/lib/docker/volumes                # vérifier la suppression du volume
docker volume ls                                   # voir les volumes existant
```

# Build et run des agent jenkins dockerizé
```
docker compose --env-file .env.agent1 -p agent1 up -d --build                         # appliquer la racine du fichier docker-compose.yml
docker compose --env-file .env.agent2 -p agent2 up -d --build                         # appliquer la racine du fichier docker-compose.yml
```
