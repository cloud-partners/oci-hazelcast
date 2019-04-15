output "Hazelcast IMDG VM public IP" {
  value = "${data.oci_core_vnic.hazelcast_vnic.public_ip_address}"
}
