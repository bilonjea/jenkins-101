# use of jenkins/jenkins:lts-jdk21 LTS + JDK21 (recommended)
# voir https://hub.docker.com/r/jenkins/jenkins/tags
# you can use fixed version like jenkins/jenkins:2.479.2-lts-jdk21
# you can also use the weekly version (more recent but less stable)
# like jenkins/jenkins:weekly-jdk21 or jenkins/jenkins:latest-jdk21 or jenkins/jenkins:jdk21

FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update && apt-get install -y lsb-release python3-pip
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

ARG PLUGINS_FILE=jenkins-plugins/plugins.txt
COPY --chown=jenkins:jenkins ${PLUGINS_FILE} /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
