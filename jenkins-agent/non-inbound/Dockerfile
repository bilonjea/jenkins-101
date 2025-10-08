# Agent Jenkins contrôlé en SSH (sshd inclus) + JDK 21
FROM jenkins/ssh-agent:latest-jdk21

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Outils système + Docker CLI (buildx/compose)
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

# Maven
ARG MAVEN_VERSION=3.9.8
ENV MAVEN_HOME=/opt/apache-maven-${MAVEN_VERSION}
ENV PATH=$MAVEN_HOME/bin:$PATH
RUN set -eux; \
  curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
  | tar -xz -C /opt; \
  ln -s "$MAVEN_HOME/bin/mvn" /usr/local/bin/mvn

# Node LTS + Angular CLI
ARG NODE_MAJOR=20
ARG ANGULAR_CLI_VERSION=latest
ENV NODE_OPTIONS=--max_old_space_size=2048
RUN set -eux; \
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -; \
  apt-get update; \
  apt-get install -y --no-install-recommends nodejs; \
  npm i -g @angular/cli@${ANGULAR_CLI_VERSION}; \
  rm -rf /var/lib/apt/lists/*

# --- SSH: injection de la clé publique & durcissement minimal ---
# Reçoit la clé publique via ARG au build
ARG JENKINS_AGENT_SSH_PUBKEY
# Crée le .ssh, injecte la pubkey et fixe les droits
RUN set -eux; \
  install -d -m 0700 /home/jenkins/.ssh; \
  if [ -n "${JENKINS_AGENT_SSH_PUBKEY:-}" ]; then \
    printf '%s\n' "${JENKINS_AGENT_SSH_PUBKEY}" > /home/jenkins/.ssh/authorized_keys; \
  fi; \
  chown -R jenkins:jenkins /home/jenkins/.ssh; \
  chmod 0600 /home/jenkins/.ssh/authorized_keys || true; \
  install -d -m 0755 /var/run/sshd; \
  printf "PasswordAuthentication no\nPubkeyAuthentication yes\nPermitRootLogin no\nUsePAM yes\n" \
    > /etc/ssh/sshd_config.d/jenkins.conf


# Labels de l’agent (ciblage dans les pipelines)
ENV JENKINS_AGENT_LABELS="build docker java21 maven node angular"

EXPOSE 22
# l’image jenkins/ssh-agent démarre déjà sshd en entrée; on laisse l’ENTRYPOINT/CMD du parent