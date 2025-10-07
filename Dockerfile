# use of jenkins/jenkins:lts-jdk21 LTS + JDK21 (recommended)
# voir https://hub.docker.com/r/jenkins/jenkins/tags
# you can use fixed version like jenkins/jenkins:2.479.2-lts-jdk21
# you can also use the weekly version (more recent but less stable)
# like jenkins/jenkins:weekly-jdk21 or jenkins/jenkins:latest-jdk21 or jenkins/jenkins:jdk21

FROM jenkins/jenkins:2.479.2-lts-jdk21

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Docker CLI + buildx + compose (sans recommends) + dépôt officiel Docker
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release \
      git openssh-client \
    ; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
    chmod a+r /etc/apt/keyrings/docker.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      docker-ce-cli docker-buildx-plugin docker-compose-plugin; \
    apt-get purge -y gnupg; \
    rm -rf /var/lib/apt/lists/*

USER jenkins

# Plugins Jenkins (installés au build)
ARG PLUGINS_FILE=jenkins-plugins/plugins.txt
COPY --chown=jenkins:jenkins ${PLUGINS_FILE} /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

