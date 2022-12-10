variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "mtorres"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "mtorres"
}

# Set TF_VAR_PASSWORD in your shell
variable "PASSWORD" {}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "http://openstack.di.ual.es:5000/v3"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "mtorres_ual"
}


