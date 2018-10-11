resource "oci_core_instance" "imdg" {
  display_name        = "imdg"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.imdg["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(format("%s\n%s\n",
      "#!/usr/bin/env bash",
      file("../scripts/imdg.sh")
    ))}"
  }
  count = "${var.imdg["node_count"]}"
}

data "oci_core_vnic_attachments" "imdg_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.imdg.*.id[0]}"
}

data "oci_core_vnic" "imdg_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.imdg_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "IMDG URL" { value = "http://${data.oci_core_vnic.imdg_vnic.public_ip_address}:5701" }
