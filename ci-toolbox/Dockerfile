# Boîte à outils CI générique (pas spécifique à Jenkins)
FROM eclipse-temurin:21-jdk-jammy

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Outils système
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg git unzip jq make python3 python3-pip lsb-release \
 && rm -rf /var/lib/apt/lists/*

# Docker CLI (+ buildx + compose) depuis le dépôt officiel Docker
RUN install -d -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list \
 && apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli docker-buildx-plugin docker-compose-plugin \
 && rm -rf /var/lib/apt/lists/*

# Maven
ARG MAVEN_VERSION=3.9.8
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | tar -xz -C /opt \
 && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn

# Node LTS + Angular CLI
ARG NODE_MAJOR=20
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
 && apt-get update && apt-get install -y --no-install-recommends nodejs \
 && npm install -g @angular/cli \
 && rm -rf /var/lib/apt/lists/*

# Python (outils multiples via pipx si besoin)
RUN pip3 install --no-cache-dir pipx && pipx ensurepath

# (Option) Quarkus CLI via JBang
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup \
 && /root/.jbang/bin/jbang app install --force quarkus@quarkusio

# Par défaut on reste root (pratique en CI). Tu peux passer non-root si nécessaire.