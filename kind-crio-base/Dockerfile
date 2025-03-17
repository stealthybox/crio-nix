ARG K8S_VERSION="v1.32.2"
FROM kindest/node:${K8S_VERSION}
ARG CRIO_VERSION="v1.32.2"
ARG CRIO_RELEASE_CHANNEL="stable:/v1.32"
ARG CRIO_REPO="https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:"

RUN echo "Installing Packages ..." 
RUN  apt-get clean \
 &&  apt-get update -y \
 &&  DEBIAN_FRONTEND=noninteractive apt-get install -y \
        software-properties-common vim gnupg \
 &&  echo "Installing cri-o ..." \
 &&  curl -fsSL ${CRIO_REPO}/${CRIO_RELEASE_CHANNEL}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg \
 &&  echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] ${CRIO_REPO}/${CRIO_RELEASE_CHANNEL}/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list \
 &&  apt-get update \
 &&  DEBIAN_FRONTEND=noninteractive apt-get --option=Dpkg::Options::=--force-confdef install -y cri-o \
 &&  sed -i 's/containerd/crio/g' /etc/crictl.yaml \
 &&  systemctl disable containerd \
 &&  systemctl enable crio
