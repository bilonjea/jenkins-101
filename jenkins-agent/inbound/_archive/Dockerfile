# Agent Jenkins JNLP avec JDK 21
FROM jenkins/inbound-agent:latest-jdk21

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Outils système
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg git unzip jq make python3 python3-pip lsb-release \
 && rm -rf /var/lib/apt/lists/*

# Docker CLI (+ buildx + compose)
RUN install -d -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
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
 && npm install -g @angular/cli@20 \
 && rm -rf /var/lib/apt/lists/*

# Python tools
RUN pip3 install --no-cache-dir pipx && pipx ensurepath

# (Option) Quarkus CLI via JBang
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup \
 && /root/.jbang/bin/jbang app install --force quarkus@quarkusio

# (Option) groupe docker pour l'utilisateur jenkins (adapter le GID au host si besoin)
# RUN groupadd -g 998 docker && usermod -aG docker jenkins

USER jenkins
# Labels utiles pour cibler cet agent dans les pipelines
ENV JENKINS_AGENT_LABELS="build docker java21 maven node angular quarkus"