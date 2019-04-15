resource "oci_core_virtual_network" "HazelcastVCN" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "HazelcastVCN"
  dns_label      = "hazelcastvcn"
}

resource "oci_core_subnet" "HazelcastSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.1.20.0/24"
  display_name        = "HazelcastSubnet"
  dns_label           = "hazelcastsubnet"
  security_list_ids   = ["${oci_core_security_list.HazelcastSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.HazelcastVCN.id}"
  route_table_id      = "${oci_core_route_table.HazelcastRT.id}"
  dhcp_options_id     = "${oci_core_virtual_network.HazelcastVCN.default_dhcp_options_id}"
}

resource "oci_core_internet_gateway" "HazelcastIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "HazelcastIG"
  vcn_id         = "${oci_core_virtual_network.HazelcastVCN.id}"
}

resource "oci_core_route_table" "HazelcastRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.HazelcastVCN.id}"
  display_name   = "HazelcastRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.HazelcastIG.id}"
  }
}
