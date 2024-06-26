module "master" {
  source    = "../../modules/rhcos-static"
  count     = length(var.master_ips)
  name      = "${var.cluster_slug}-master${count.index + 1}"
  folder    = "awesomo/redhat/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme500.id
  disk_size = 150
  memory    = 8192
  num_cpu   = 8
  ignition  = file(var.master_ignition_path)

  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

  network      = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name    = var.domain_name
  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_addresses  = var.dns_addresses
  gateway        = var.gateway
  ipv4_address   = var.master_ips[count.index]
  netmask        = var.netmask
}

module "worker" {
  source    = "../../modules/rhcos-static"
  count     = length(var.worker_ips)
  name      = "${var.cluster_slug}-worker${count.index + 1}"
  folder    = "awesomo/redhat/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme500.id
  disk_size = 150
  memory    = 8192
  num_cpu   = 8
  ignition  = file(var.worker_ignition_path)

  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

  network      = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name    = var.domain_name
  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_addresses  = var.dns_addresses
  gateway        = var.gateway
  ipv4_address   = var.worker_ips[count.index]
  netmask        = var.netmask
}

module "bootstrap" {
  source    = "../../modules/rhcos-static"
  count     = "${var.bootstrap_complete ? 0 : 1}"
  name      = "${var.cluster_slug}-bootstrap"
  folder    = "awesomo/redhat/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme500.id
  disk_size = 150
  memory    = 8192
  num_cpu   = 8
  ignition  = file(var.bootstrap_ignition_path)

  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

  network      = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name    = var.domain_name
  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_addresses  = var.dns_addresses
  gateway        = var.gateway
  ipv4_address   = var.bootstrap_ip
  netmask        = var.netmask
}



# output "ign" {
#   value = module.lb.ignition
# }
