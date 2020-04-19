# terraform-openstack-kubernetes
## Terraform module for deploy kubernetes infrastructure
This module use OpenStack API

## For using run:
```bash
git clone https://github.com/ptsgr/terraform-openstack-kubernetes.git
cd terraform-openstack-kubernetes
terraform init # for update dependence
terraform apply # for run module
```
## To use the module you must enter the parameters
```bash
TF_VAR_cloud_user_name = "your username"
TF_VAR_cloud_user_pass = "your password"
TF_VAR_cloud_auth_url    = "openstack url"
TF_VAR_cloud_tenant_id ="openstack project name"
TF_VAR_external_network_name = "external network name"
TF_VAR_cloud_network_id = "internal network id"
TF_VAR_cluster_VIP = "false" # default = false
#cluster_VIP is cluster virtual ip, by default use keepalived.

TF_VAR_cluster_name = "cluster name"
TF_VAR_vms_image_id = "image id"
TF_VAR_vms_ssh_key = "ssh public key" # use for create key-pair

TF_VAR_master_count = "master nodes count" # default = "1"
TF_VAR_master_flavor_id = "master flavor id"

TF_VAR_workers_count = "worker nodes count"
TF_VAR_worker_flavor_id = "worker flavor id"
```
## For HA scheme use parameters
```bash
TF_VAR_cluster_VIP = "true" # default = false
TF_VAR_master_count = "3"   # default = 1
```
## This module returns
```bash
master_name
master_inter_ip
master_fip
workers_names
workers_fips
``` 
