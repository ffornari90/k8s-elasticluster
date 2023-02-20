# k8s-elasticluster

A Docker image to build a Kubernetes cluster on OpenStack with elasticluster.
You need to set a bunch of environment variables in order to properly deploy the docker container:

``` bash
PROJECT_NAME=<openstack_project_name>
USER_NAME=<openstack_username>
AUTH_URL=<openstack_auth_url>
REGION_NAME=<openstack_region>
APPLICATION_CREDENTIAL_ID=<openstack_application_credential_id>
APPLICATION_CREDENTIAL_SECRET=<openstack_application_credential_secret>
FLAVOR=<openstack_flavor>
NETWORK_IDS=<openstack_private_network_ids>
SECURITY_GROUP=<openstack_security_group>
FLOATING_NETWORK_ID=<openstack_public_network_id>
IMAGE_ID=<openstack_vm_image_id>
LOGIN=<openstack_vm_login_user>
MASTER_NODES=<number_of_k8s_master_nodes>
WORKER_NODES=<number_of_k8s_worker_nodes>
TIMEOUT=<openstack_vm_creation_timeout>
```
