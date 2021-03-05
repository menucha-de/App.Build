ARG DIST
FROM debian:${DIST}-slim
ARG DIST

ARG VERSION=node_10.x

RUN mkdir /usr/share/man/man1/ && \
    echo "deb http://httpredir.debian.org/debian/ ${DIST}-backports main non-free contrib" > /etc/apt/sources.list.d/backports.list  && \
    dpkg --add-architecture armhf && \
    apt-get update -qq && \
    apt-get install -q -y --no-install-recommends wget gnupg curl git build-essential crossbuild-essential-armhf libc6:armhf debhelper apt-transport-https default-jdk-headless zip unzip ant-optional ivy libjsch-java openssh-client jq && \
    ln -s ../../java/ivy.jar /usr/share/ant/lib && \
    if [ "${DIST}" = "stretch" ]; then apt-get install -q -y --no-install-recommends openjdk-11-jdk-headless fakeroot; update-java-alternatives -s java-1.8.0-openjdk-amd64; fi && \
    apt-get install -q -y --no-install-recommends -t ${DIST}-backports golang && \
    wget -qO - http://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb http://deb.nodesource.com/$VERSION ${DIST} main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update -qq && \
    apt-get install -q -y --no-install-recommends nodejs && \
    apt-get clean && rm /var/lib/apt/lists/*_* /etc/apt/sources.list.d/backports.list

COPY mkapp /usr/share/mkapp/functions
