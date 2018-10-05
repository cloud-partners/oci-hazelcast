output "1 - MemberNode 1 SSH login " {
value = <<END
	ssh -i ~/.ssh/id_rsa ubuntu@${data.oci_core_vnic.member_node_vnic.public_ip_address}
END
}


