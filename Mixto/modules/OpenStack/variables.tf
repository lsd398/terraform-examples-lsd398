# *** YOUR CODE HERE ***
# Definir estas 4 variables
# * openstack_user_name inicializada con el nombre de usuario en OpenStack
# * openstack_tenant_name inicializada con el nombre del proyecto en OpenStack
# * openstack_password inicializada con la contraseña en OpenStack
# * openstack_keypair: Nombre del archivo de claves en OpenStack
variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "lsd398"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "lsd398"
}

variable "PASSWORD"{}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "http://openstack.di.ual.es:5000/v3"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "lsd398"
}


