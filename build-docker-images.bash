docker login -u TON_USER


# CI neutre
docker build -t TON_USER/ci-toolbox:latest ./ci-toolbox
docker push TON_USER/ci-toolbox:latest


# Agent Jenkins
docker build -t TON_USER/jenkins-agent:java21 ./jenkins-agent
docker push TON_USER/jenkins-agent:java21

# Tu peux aussi expliciter le registre :
docker build -t docker.io/TON_USER/ci-toolbox:latest ./ci-toolbox  


# Multi-arch (optionnel, propre pour amd64/arm64)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t TON_USER/ci-toolbox:1.0.0 \
  -t TON_USER/ci-toolbox:latest \
  --push ./ci-toolbox

docker buildx build --platform linux/amd64,linux/arm64 \
  -t TON_USER/jenkins-agent:java21-1.0.0 \
  -t TON_USER/jenkins-agent:java21 \
  --push ./jenkins-agent


