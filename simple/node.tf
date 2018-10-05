resource "oci_core_instance" "hazelcast" {
  display_name        = "hazelcast"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.hazelcast["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(format("%s\n%s\n%s\n",
      "#!/usr/bin/env bash",
      "version=${var.hazelcast["version"]}",
      file("../scripts/node.sh")
    ))}"
  }
  count = "${var.hazelcast["node_count"]}"
}

data "oci_core_vnic_attachments" "hazelcast_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.hazelcast.*.id[0]}"
}

data "oci_core_vnic" "hazelcast_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.hazelcast_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "HazelcastURL" { value = "http://${data.oci_core_vnic.hazelcast_vnic.public_ip_address}:1234" }
