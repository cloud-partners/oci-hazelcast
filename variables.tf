###
## Variables here are sourced from env, but still need to be initialized for Terraform
###

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" { default = "us-phoenix-1" }

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}


## An AD to deploy the Confluent platform. Valid values: 1,2,3 for regions with 3 ADs
variable "AD" { default = "2" }


variable "InstanceImageOCID" {
	type = "map"
        default = {
                // See https://docs.us-phoenix-1.oraclecloud.com/images/ or https://docs.cloud.oracle.com/iaas/images/
                // Oracle-provided image "Canonical-Ubuntu-14.04-2018.09.19-0"
        	eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa6micmtswnv7i62qgateumz75qlgqehppovejdoabpjrcwubzd2aq"
                us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa27bbh3lf5omuatuvpwvnr6koyusrpuv52suyheyygtxuxdnui6wq"
                uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaa3zaffzo64viydor5iqxmv3tsfrw6lafhvhnlmnmjdcvp6juquqzq"
                us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaa2o63ny6htr3z2o42ryaifuqevoml3h7idsdoabwxf3whw5qsq77q"
	}
}

variable "MemberNodeCount" { default = "1" } 


variable "MemberInstanceShape" {
  default = "VM.Standard2.1"
}





## Cluster Info
variable "ClusterName" {
  default = "ocihzct"
}





variable "MinHeapSize" { default = "4G" }

variable "MaxHeapSize" { default = "4G" }





