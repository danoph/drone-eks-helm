FROM python:3.7.1-alpine3.8
LABEL maintainer="Daniel Errante <danoph@gmail.com>"

ENV HELM_VERSION="v2.11.0"

RUN \
  apk add --update ca-certificates && \
  apk add -t deps curl && \
  apk add bash

RUN \
  curl -Lo /usr/local/bin/aws-iam-authenticator \
    https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /usr/local/bin/aws-iam-authenticator && \
  aws-iam-authenticator help

RUN \
  curl -Lo /usr/local/bin/kubectl \
    https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  kubectl version --short --client

RUN \
  curl -Lo /tmp/helm.tar.gz \
    https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
  tar -xvf /tmp/helm.tar.gz -C /tmp && \
  mv /tmp/linux-amd64/helm /usr/local/bin && \
  rm -rf /tmp/*

RUN \
  pip install awscli --upgrade && \
  aws --version

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
