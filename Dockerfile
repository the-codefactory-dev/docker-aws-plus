FROM alpine:latest

ENV TERRAFORM_VERSION="0.12.25"
ENV KUBE_LATEST_VERSION="1.15.10"
ENV HELM_VERSION="v3.1.2"

RUN apk update

RUN apk --no-cache add \
  ca-certificates \
  groff \
  less \
  curl \
  wget \
  openssl \
  git \
  ca-certificates \
  bash \
  jq \
  python3

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl 

RUN wget -q https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBE_LATEST_VERSION}/2020-02-22/bin/linux/amd64/aws-iam-authenticator -O /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator

RUN wget -q https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

ENTRYPOINT ["/bin/bash"]
