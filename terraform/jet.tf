resource "oci_core_instance" "jet" {
  display_name        = "jet"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.imdg["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  source_details {
    source_id   = "${var.images[var.region]}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"

    user_data = "${base64encode(format("%s\n%s\n",
      "#!/usr/bin/env bash",
      file("../scripts/jet.sh")
    ))}"
  }

  count = "${var.jet["node_count"]}"
}

data "oci_core_vnic_attachments" "jet_vnic_attachments" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.jet.*.id[0]}"
}

data "oci_core_vnic" "jet_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.jet_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "Jet Job Health Dashboard" {
  value = "http://${data.oci_core_vnic.jet_vnic.public_ip_address}:5701"
}
