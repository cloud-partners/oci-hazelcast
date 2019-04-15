resource "oci_core_security_list" "HazelcastSecurityList" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.HazelcastVCN.id}"
  display_name   = "HazelcastSecurityList"

  egress_security_rules = [
    {
      protocol    = "6"
      destination = "0.0.0.0/0"
    },
  ]

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "5701"
      min = "5701"
    }
  }
}
