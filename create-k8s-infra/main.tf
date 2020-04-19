provider "openstack" {
    user_name   = "${var.cloud_user_name}"
    tenant_id   = "${var.cloud_tenant_id}"
    password    = "${var.cloud_user_pass}"
    auth_url    = "${var.cloud_auth_url}"
    insecure    = true
}

resource "openstack_compute_keypair_v2" "user_key" {
  name       = "admin-key-${var.cluster_name}"
  public_key = "${var.vms_ssh_key}"
}

resource "openstack_compute_secgroup_v2" "k8s-os" {
	name        = "k8s-os-${var.cluster_name}"
	description = "K8S Openshift general security group for ${var.cluster_name}"

	rule {
		from_port	= 1
		to_port		= 65535
		ip_protocol	= "tcp"
		cidr		= "0.0.0.0/0"
	}

	rule {
                from_port       = 1
                to_port         = 65535
                ip_protocol     = "udp"
                cidr            = "0.0.0.0/0"
        }

	rule {
		from_port   	= -1
		to_port     	= -1
		ip_protocol 	= "icmp"
		cidr        	= "0.0.0.0/0"
	}
}
// ------------ Create cluster VIP ------------
resource "openstack_networking_port_v2" "cluster-vip-port" {
  count = "${var.cluster_VIP != "true" ? 0 : 1}"
  name			= "${var.cluster_name}-vip-port-${count.index}"
  network_id		= "${var.cloud_network_id}"
  admin_state_up	= true
}

resource "openstack_networking_floatingip_v2" "cluster-vip" {
	count = "${var.cluster_VIP != "true" ? 0 : 1}"
    pool = "${var.external_network_name}"
}

resource "openstack_networking_floatingip_associate_v2" "cluster-vip-attach" {
  count = "${var.cluster_VIP != "true" ? 0 : 1}"
   floating_ip = "${element(openstack_networking_floatingip_v2.cluster-vip.*.address, count.index)}"
   port_id = "${element(openstack_networking_port_v2.cluster-vip-port.*.id, count.index)}"
}

// ------------ Create master nodes ------------
resource "openstack_networking_port_v2" "k8s-master-port" {
	count = "${var.master_count}"
	name		= "${var.cluster_name}-master-port-${count.index}"
	network_id	= "${var.cloud_network_id}"
	admin_state_up	= true
}


resource "openstack_compute_instance_v2" "k8s-master" {
	count = "${var.master_count}"
	name		= "${var.cluster_name}-master-${count.index}"
    image_id    = "${var.vms_image_id}"
	flavor_id	= "${var.master_flavor_id}"
	key_pair	= "${openstack_compute_keypair_v2.user_key.name}"
	security_groups = ["${openstack_compute_secgroup_v2.k8s-os.name}"]
	

	network {
		port = "${element(openstack_networking_port_v2.k8s-master-port.*.id, count.index)}"
	}
}


resource "openstack_networking_floatingip_v2" "k8s-master-fip" {
	count = "${var.master_count}"
	pool = "${var.external_network_name}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s-master-fipa" {
	count = "${var.master_count}"
    floating_ip = "${element(openstack_networking_floatingip_v2.k8s-master-fip.*.address, count.index)}"
    instance_id = "${element(openstack_compute_instance_v2.k8s-master.*.id, count.index)}"
}


// ------------ Create worker nodes ------------
resource "openstack_networking_port_v2" "k8s-worker-port" {
    count = "${var.workers_count}"
	name		= "${var.cluster_name}-worker-port-${count.index}"
	network_id	= "${var.cloud_network_id}"
	admin_state_up	= true
}


resource "openstack_compute_instance_v2" "k8s-workers" {
    count = "${var.workers_count}"
	name		= "${var.cluster_name}-worker-${count.index}"
    image_id    = "${var.vms_image_id}"
	flavor_id	= "${var.worker_flavor_id}"
	key_pair	= "${openstack_compute_keypair_v2.user_key.name}"
	security_groups = ["${openstack_compute_secgroup_v2.k8s-os.name}"]
	

	network {
        port = "${element(openstack_networking_port_v2.k8s-worker-port.*.id, count.index)}"
	}
}


resource "openstack_networking_floatingip_v2" "k8s-worker-fip" {
    count = "${var.workers_count}"
	pool = "${var.external_network_name}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s-worker-fipa" {
    count = "${var.workers_count}"
    floating_ip = "${element(openstack_networking_floatingip_v2.k8s-worker-fip.*.address, count.index)}"
    instance_id = "${element(openstack_compute_instance_v2.k8s-workers.*.id, count.index)}"
}