FROM ubuntu:20.04
ENV PYTHONPATH=/elasticluster-install/lib/python3.8/site-packages
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/elasticluster-install/bin
COPY ./assets/tasks/kubernetes-specific.yml /
COPY ./assets/elasticluster/config /
RUN apt update && apt install -y git python3 python3-pip gettext-base \
 && pip3 install ansible==2.9.27 Babel pytz \
 && git clone https://github.com/pansapiens/elasticluster.git \
 && cd elasticluster \
 && git switch feature/openstack-app-creds \
 && sed -i 's#kubernetes_helm_stable_repo: https://kubernetes-charts.storage.googleapis.com#\
kubernetes_helm_stable_repo: https://charts.helm.sh/stable#g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-apps/defaults/main.yml \
 && sed -i 's#kubernetes_version: latest#kubernetes_version: 1.23.8-0#g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-common/defaults/main.yml \
 && sed -i 's#    manifest: https://docs.projectcalico.org/manifests/calico.yaml#\
    manifest: https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml#g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-master/defaults/main.yml \
 && sed -i '/^{/a \ \ "exec-opts": ["native.cgroupdriver=systemd"],' \
 /elasticluster/elasticluster/share/playbooks/roles/docker-ce/files/etc/docker/daemon.json \
 && sed -i 's#apiVersion: rbac.authorization.k8s.io/v1beta1#apiVersion: rbac.authorization.k8s.io/v1#g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-apps/files/create_ClusterRoleBinding.yaml \
 && sed -i 's#  shell: helm install openebs stable/openebs --version 1.9.0 --namespace openebs --kubeconfig \
/etc/kubernetes/admin.conf#  shell: helm repo add openebs https://openebs.github.io/charts \&\& helm install \
openebs openebs/openebs --version 3.3.1 --namespace openebs --kubeconfig /etc/kubernetes/admin.conf#g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-apps/tasks/openebs.yml \
 && sed -i '/    state: '"'"'{{ pkg_install_state }}'"'"'/ r /kubernetes-specific.yml' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-common/tasks/RedHat.yml \
 && sed -i 's/={{ kubernetes_version }}/="{{ kubernetes_version }}0"/g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-common/tasks/Debian.yml \
 && sed -i 's/kubernetes_default_networking: calico/kubernetes_default_networking: flannel/g' \
 /elasticluster/elasticluster/share/playbooks/roles/kubernetes-master/defaults/main.yml \ 
 && mkdir -p ../elasticluster-install/lib/python3.8/site-packages \
 && python3 setup.py install --prefix=../elasticluster-install \
 && groupadd -g 1000 user \
 && useradd -ms /bin/bash -u 1000 -g 1000 user
USER user
WORKDIR /home/user
RUN mkdir /home/user/.elasticluster
CMD ["/bin/sh", "-c", "envsubst '$${PROJECT_NAME},$${USER_NAME},$${AUTH_URL},$${REGION_NAME},\
$${APPLICATION_CREDENTIAL_ID},$${APPLICATION_CREDENTIAL_SECRET},$${FLAVOR},$${NETWORK_IDS},\
$${SECURITY_GROUP},$${FLOATING_NETWORK_ID},$${IMAGE_ID},$${LOGIN},$${MASTER_NODES},\
$${WORKER_NODES},$${TIMEOUT}' < /config > .elasticluster/config \
    && sleep infinity"]
