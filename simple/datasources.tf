# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

data "template_file" "boot_script" {
  template =  "${file("scripts/boot.sh.tpl")}"
  vars {
    ClusterName = "${var.ClusterName}"
    MIN_HEAP_SIZE = "${var.MinHeapSize}"
    MAX_HEAP_SIZE = "${var.MaxHeapSize}"
    MemberNodeCount = "${var.MemberNodeCount}"
    VPCCIDR = "${var.VPC-CIDR}"
  }
}


# Get list of VNICS for Member Nodes
data "oci_core_vnic_attachments" "member_node_vnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  instance_id = "${oci_core_instance.MemberNode.0.id}"
}

data "oci_core_vnic" "member_node_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.member_node_vnics.vnic_attachments[0],"vnic_id")}"
}

 
