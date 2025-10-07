# Inbound agent JNLP/WebSocket + JDK 21
# REMPLACE éventuellement par un tag précis/digest après vérification sur Docker Hub :
# FROM jenkins/inbound-agent@sha256:<digest-verifie>
FROM jenkins/inbound-agent:latest-jdk21

USER root
ENV DEBIAN_FRONTEND=noninteractive

# --- Outils système + Docker CLI (buildx/compose) en une seule couche ---
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg git openssh-client unzip jq make python3 python3-pip lsb-release; \
  install -m 0755 -d /etc/apt/keyrings; \
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
  chmod a+r /etc/apt/keyrings/docker.gpg; \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list; \
  apt-get update; \
  apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin; \
  rm -rf /var/lib/apt/lists/*

# --- Maven ---
ARG MAVEN_VERSION=3.9.8
ENV MAVEN_HOME=/opt/apache-maven-${MAVEN_VERSION}
ENV PATH=$MAVEN_HOME/bin:$PATH
RUN set -eux; \
  curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
  | tar -xz -C /opt; \
  ln -s "$MAVEN_HOME/bin/mvn" /usr/local/bin/mvn

# --- Node LTS + Angular CLI ---
ARG NODE_MAJOR=20
ARG ANGULAR_CLI_VERSION=20.3.4    # ou fixe: 18.2.12 / 19.x
ENV NODE_OPTIONS=--max_old_space_size=2048
RUN set -eux; \
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -; \
  apt-get update; \
  apt-get install -y --no-install-recommends nodejs; \
  npm install -g @angular/cli@${ANGULAR_CLI_VERSION}; \
  rm -rf /var/lib/apt/lists/*

# --- (Optionnel) Quarkus CLI via JBang ---
# RUN curl -Ls https://sh.jbang.dev | bash -s - app setup \
#  && /root/.jbang/bin/jbang app install --force quarkus@quarkusio

# --- (Option) ajuster le groupe docker pour le socket du host ---
# ATTENTION: mappe le GID docker du host via compose si tu montes /var/run/docker.sock
# RUN groupadd -g 998 docker && usermod -aG docker jenkins

USER jenkins

# Labels pour ciblage dans les pipelines
ENV JENKINS_AGENT_LABELS="build docker java21 maven node angular"
