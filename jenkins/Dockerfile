# Fase de construção
FROM alpine:3.14 AS builder

# Defina as variáveis de ambiente
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_WAR_PATH /usr/share/jenkins
ENV REF_PATH ${JENKINS_WAR_PATH}/ref
ENV USER jenkins
ENV JENKINS_VERSION=2.411

WORKDIR ${JENKINS_HOME}

# Crie os diretórios necessários
RUN mkdir -p ${JENKINS_HOME} ${REF_PATH}/init.groovy.d

# Instale os pacotes necessários
RUN apk update && apk add --no-cache \
    ca-certificates \
    openjdk11 \
    openssh \
    coreutils \
    sudo \
    bash \
    vim \
    curl \
    git \
    gnupg \
    musl-locales \
    tzdata \
    zip \
    iptables \
    musl-locales-lang \
    btrfs-progs \
    parallel \
    docker \
    netcat-openbsd \
    bind-tools \
    xz \
    aws-cli \
    ttf-dejavu \
    groff \
    && addgroup -g 1000 ${USER} \
    && adduser -h ${JENKINS_HOME} -u 1000 -G ${USER} -s /bin/bash -D ${USER} \
    && addgroup ${USER} docker

# Instale outras ferramentas como kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/bin/kubectl

# Baixe os arquivos do Jenkins
ARG JENKINS_WAR_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
ARG JENKINS_PLUGIN_MANAGER=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.11/jenkins-plugin-manager-2.12.11.jar

# Download jenkins files
ADD ${JENKINS_WAR_URL} ${JENKINS_WAR_PATH}/jenkins.war
ADD ${JENKINS_PLUGIN_MANAGER} ${JENKINS_HOME}/jenkins-plugin-manager.jar

# Instale os plugins do Jenkins
COPY conf/plugins.txt ${REF_PATH}/plugins.txt
COPY conf/set_jenkins_conf.groovy ${REF_PATH}/set_jenkins_conf.groovy
RUN java -jar ${JENKINS_HOME}/jenkins-plugin-manager.jar -f ${REF_PATH}/plugins.txt --verbose

# Aplique as configurações de segurança
COPY scripts/hardening.sh /usr/local/bin/hardening.sh
RUN /usr/local/bin/hardening.sh

# Copie os scripts necessários
COPY scripts/jenkins-support /usr/local/bin/jenkins-support
COPY scripts/jenkins.sh /usr/local/bin/jenkins.sh
RUN mv ${REF_PATH}/*.groovy ${REF_PATH}/init.groovy.d/

# Mude a propriedade dos arquivos necessários
RUN chown ${USER}: ${JENKINS_HOME} ${JENKINS_WAR_PATH} /usr/local/bin -R


# Fase final
FROM alpine:3.14

# Defina as variáveis de ambiente
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_WAR_PATH /usr/share/jenkins
ENV USER jenkins

WORKDIR ${JENKINS_HOME}

# Instale os pacotes necessários
RUN apk update && apk add --no-cache \
    ca-certificates \
    openjdk11 \
    openssh \
    coreutils \
    sudo \
    bash \
    vim \
    curl \
    git \
    gnupg \
    musl-locales \
    tzdata \
    zip \
    iptables \
    musl-locales-lang \
    btrfs-progs \
    parallel \
    docker \
    netcat-openbsd \
    bind-tools \
    xz \
    aws-cli \
    ttf-dejavu \
    groff \
    && addgroup -g 1000 ${USER} \
    && adduser -h ${JENKINS_HOME} -u 1000 -G ${USER} -s /bin/bash -D ${USER} \
    && addgroup ${USER} docker

# Copie os diretórios necessários da fase de construção
COPY --from=builder --chown=${USER} ${JENKINS_HOME} ${JENKINS_HOME}
COPY --from=builder --chown=${USER} ${JENKINS_WAR_PATH} ${JENKINS_WAR_PATH}
COPY --from=builder --chown=${USER} /usr/local/bin /usr/local/bin

EXPOSE 8080
EXPOSE 443
EXPOSE 50000

USER ${USER}

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
