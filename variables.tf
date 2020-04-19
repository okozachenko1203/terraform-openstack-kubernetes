variable "cloud_user_name" {
  description = "User for connect to cloud api"
  type = "string"
}
variable "cloud_user_pass" {
  description = "Password for connect to cloud api"
  type = "string"
}
variable "cloud_auth_url" {
  description = "url for connection to cloud api"
  type = "string"
}
variable "cloud_tenant_id" {
  description = "Project id in the cloud"
  type = "string"
}
variable "cluster_VIP" {
  description = "Virtual IP for cluster"
  type = "string"
  default = "false"
}
variable "cluster_name" {
  description = "Cluster name will use for nodes"
  type = "string"
}
variable "vms_image_id" {
  description = "OS image for nodes"
  type = "string"
}

variable "vms_ssh_key" {
  description = "public ssh key for connect to vms you mast have private key"
  type = "string"
}
variable "master_count" {
  description = "Master nodes count"
  type = "string"
  default = "1"
}
variable "master_flavor_id" {
  description = "Master node params"
  type = "string"
}
variable "workers_count" {
  description = "Worker nodes count"
  type = "string"
  default = "0"
}

variable "worker_flavor_id" {
  description = "Worker nodes params"
  type = "string"
}

variable "external_network_name"{
  description = "External network name"
  type = "string"
  default = "ext-net"
}

variable "cloud_network_id" {
  description = "Internal network id"
  type = "string"
}
