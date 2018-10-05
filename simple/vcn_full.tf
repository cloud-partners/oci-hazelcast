variable "VPC-CIDR" {
  default = "10.0.0.0/16"
}

resource "oci_core_virtual_network" "hazelcast_vcn" {
  cidr_block = "${var.VPC-CIDR}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "hazelcast_vcn"
  dns_label = "hazelcastvcn"
}

resource "oci_core_internet_gateway" "hazelcast_internet_gateway" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "hazelcast_internet_gateway"
    vcn_id = "${oci_core_virtual_network.hazelcast_vcn.id}"
}

resource "oci_core_route_table" "RouteForComplete" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.hazelcast_vcn.id}"
    display_name = "RouteTableForComplete"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.hazelcast_internet_gateway.id}"
    }
}

resource "oci_core_security_list" "PublicSubnet" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "Public Subnet"
    vcn_id = "${oci_core_virtual_network.hazelcast_vcn.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 22
            "min" = 22
        }
        protocol = "6"
        source = "0.0.0.0/0"
    }]
    ingress_security_rules = [{
        protocol = "6"
	source = "${var.VPC-CIDR}"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 5701
            "min" = 5701
        }
        protocol = "6"
        source = "0.0.0.0/0"
    }]

}



## Publicly Accessable Subnet Setup

resource "oci_core_subnet" "public" {
  count = "3"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "${cidrsubnet(var.VPC-CIDR, 8, count.index)}"
  display_name = "public_${count.index}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.hazelcast_vcn.id}"
  route_table_id = "${oci_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${oci_core_security_list.PublicSubnet.id}"]
  dhcp_options_id = "${oci_core_virtual_network.hazelcast_vcn.default_dhcp_options_id}"
  dns_label = "public${count.index}"
}


