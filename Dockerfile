FROM alpine:3.8
RUN apk -v --update add \
          bash \
          python \
          py-pip \
          groff \
          less \
          wget ca-certificates \
          mailcap \
          && \
      pip install --upgrade awscli s3cmd python-magic && \
      apk -v --purge del py-pip && \
      rm /var/cache/apk/*

WORKDIR /root

ENV TERRAFORM_VERSION=0.11.8
ENV TERRAGRUNT_VERSION=0.16.10

# terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
  mv terraform /bin &&\
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 &&\
  mv terragrunt_linux_amd64 /bin/terragrunt &&\
  chmod +x /bin/terragrunt

# terraform providers
ENV TF_PLUGIN_CACHE_DIR="/terraform-plugin-cache"
ENV AWS_REGION=eu-west-3

RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}
RUN mkdir providers
COPY providers ./providers

RUN cd providers; terraform init
