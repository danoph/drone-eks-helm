FROM python:3.8.1-alpine3.11
LABEL maintainer="Daniel Errante <danoph@gmail.com>"

ENV HELM_VERSION="v2.12.0"

RUN apk add --update bash curl ca-certificates openssl

RUN pip install awscli --upgrade \
  && aws --version

RUN curl -Lo /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x /usr/local/bin/aws-iam-authenticator \
  && aws-iam-authenticator help

RUN curl -Lo /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --short --client

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh \
  && chmod +x ./get_helm.sh \
  && ./get_helm.sh -v $HELM_VERSION \
  && helm help

CMD ["/bin/sh"]
