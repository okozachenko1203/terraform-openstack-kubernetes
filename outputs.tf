output "master_name" {
  value = "${openstack_compute_instance_v2.k8s-master.*.name}"
}

output "master_inter_ip" {
  value = "${openstack_compute_instance_v2.k8s-master.*.access_ip_v4}"
}

output "master_fip" {
    value = "${openstack_networking_floatingip_v2.k8s-master-fip.*.address}"
}

output "workers_names" {
  value = "${openstack_compute_instance_v2.k8s-workers.*.name}"
}

output "workers_fips" {
  value = "${openstack_networking_floatingip_v2.k8s-worker-fip.*.address}"
}
