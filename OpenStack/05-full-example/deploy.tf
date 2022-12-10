#Obtener la red ext-net
data "openstack_networking_network_v2" "ext-net" {
  name = "ext-net"
}

#Creamos la red desarrollo
resource "openstack_networking_network_v2" "desarrollo_net" {
  name           = "desarrollo-net"
  admin_state_up = "true"
}

#Creamos la subred desarrollo
resource "openstack_networking_subnet_v2" "desarrollo_subnet" {
  name            = "desarrollo-subnet"
  network_id      = openstack_networking_network_v2.desarrollo_net.id
  cidr            = "10.2.0.0/24"
  dns_nameservers = ["150.214.156.2", "8.8.8.8"]
  ip_version      = 4
}

#Creamos el router desarrollo
resource "openstack_networking_router_v2" "desarrollo_router" {
  name                = "desarrollo-router"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.ext-net.id
}

#Añadir segunda interfaz de red a la subred management
resource "openstack_networking_router_interface_v2" "desarrollo_int_2" {
  router_id = openstack_networking_router_v2.desarrollo_router.id
  subnet_id = openstack_networking_subnet_v2.desarrollo_subnet.id
}

#Crear nodo mysql
resource "openstack_compute_instance_v2" "mysql" {
  name              = "mysql"
  image_name        = "Ubuntu 16.04 LTS"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = "desarrollo-net"
  }

  user_data = file("install_mysql.sh")

  depends_on = [openstack_networking_network_v2.desarrollo_net]

}

data "template_file" "install_appserver" {
  template = file("install_appserver.tpl")
  vars = {
    mysql_ip = openstack_compute_instance_v2.mysql.network.0.fixed_ip_v4
  }
  depends_on = [openstack_compute_instance_v2.mysql]
}

#Crear nodo appserver
resource "openstack_compute_instance_v2" "appserver" {
  name              = "appserver"
  image_name        = "Ubuntu 16.04 LTS"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = "desarrollo-net"
  }

  user_data = data.template_file.install_appserver.rendered

  depends_on = [openstack_networking_network_v2.desarrollo_net,
  openstack_compute_instance_v2.mysql]

}

resource "openstack_networking_floatingip_v2" "mysql_ip" {
  pool = "ext-net"
}

resource "openstack_networking_floatingip_v2" "appserver_ip" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "mysql_ip" {
  floating_ip = openstack_networking_floatingip_v2.mysql_ip.address
  instance_id = openstack_compute_instance_v2.mysql.id
}

resource "openstack_compute_floatingip_associate_v2" "appserver_ip" {
  floating_ip = openstack_networking_floatingip_v2.appserver_ip.address
  instance_id = openstack_compute_instance_v2.appserver.id
}

output MySQL_Floating_IP {
  value      = openstack_networking_floatingip_v2.mysql_ip.address
  depends_on = [openstack_networking_floatingip_v2.mysql_ip]
}

output Appserver_Floating_IP {
  value      = openstack_networking_floatingip_v2.appserver_ip.address
  depends_on = [openstack_networking_floatingip_v2.appserver_ip]
}


