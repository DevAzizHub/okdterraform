data "vsphere_virtual_machine" "template" {
  name          = var.rhcos_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "master" {
  source    = "../../modules/rhcos-static"
  count     = length(var.master_ips)
  name      = "master${count.index + 1}"
  folder    = "${var.vmware_folder}/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme.id
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

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_address    = "${var.local_dns}${var.basedomain}"
  gateway        = var.gateway
  ipv4_address   = var.master_ips[count.index]
  netmask        = var.netmask
}

module "worker" {
  source    = "../../modules/rhcos-static"
  count     = length(var.worker_ips)
  name      = "worker${count.index + 1}"
  folder    = "${var.vmware_folder}/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme.id
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

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_address    = "${var.local_dns}${var.basedomain}"
  gateway        = var.gateway
  ipv4_address   = var.worker_ips[count.index]
  netmask        = var.netmask
}

module "bootstrap" {
  source    = "../../modules/rhcos-static"
  count     = "${var.bootstrap_complete ? 0 : 1}"
  name      = "bootstrap"
  folder    = "${var.vmware_folder}/${var.cluster_slug}"
  datastore = data.vsphere_datastore.nvme.id
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

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr
  dns_address    = "${var.local_dns}${var.basedomain}"
  gateway        = var.gateway
  ipv4_address   = var.bootstrap_ip
  netmask        = var.netmask
}



# output "ign" {
#   value = module.lb.ignition
# }


