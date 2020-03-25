FROM ubuntu:18.04

# Change default shell to sh
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    gnupg2 \
    curl \
    wget \
    locales && \
    rm -rf /var/lib/apt/lists/*

# Set default language to US and UTF8 encoding
RUN locale-gen "en_US.UTF-8"

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list 
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

COPY monitor /usr/local/bin/monitor
RUN chmod a+x /usr/local/bin/monitor

RUN mkdir -p ~/.kube
COPY config ~/.kube/config
RUN export KUBECONFIG=~/.kube/config
