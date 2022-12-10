#Crear nodo mysql
resource "openstack_compute_instance_v2" "mysql" {
  name              = "mysql"
  image_name        = "Ubuntu 16.04 LTS"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = "mtorres-net"
  }

  user_data = file("install_mysql.sh")
}


resource "openstack_networking_floatingip_v2" "mysql_ip" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "mysql_ip" {
  floating_ip = openstack_networking_floatingip_v2.mysql_ip.address
  instance_id = openstack_compute_instance_v2.mysql.id
}

output MySQL_Floating_IP {
  value      = openstack_networking_floatingip_v2.mysql_ip.address
  depends_on = [openstack_networking_floatingip_v2.mysql_ip]
}



