FROM debian:buster-slim

RUN apt-get update
RUN apt-get -y install curl ca-certificates curl apt-transport-https lsb-release gnupgs software-properties-common

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update
RUN apt-get -y install terraform

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update
RUN apt-get -y install azure-cli

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get -y install apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update
RUN apt-get -y install google-cloud-sdk

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* 

WORKDIR /workspace

RUN groupadd --gid 1001 nonroot && useradd --gid nonroot --create-home --uid 1001 nonroot && chown nonroot:nonroot /workspace
USER nonroot

CMD ["bash"]
