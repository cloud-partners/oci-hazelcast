
resource "oci_core_instance" "MemberNode" {
  count		      = "${var.MemberNodeCount}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "HZLCST Member ${format("%01d", count.index+1)}"
  hostname_label      = "HZLCST-Member-${format("%01d", count.index+1)}"
  shape               = "${var.MemberInstanceShape}"
  subnet_id           = "${oci_core_subnet.public.*.id[var.AD - 1]}"

  source_details {
    source_type = "image"
    source_id = "${var.InstanceImageOCID[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.boot_script.rendered)}"
  }

  timeouts {
    create = "30m"
  }

}



