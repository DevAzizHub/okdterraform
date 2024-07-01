## Node IPs
bootstrap_ip = "10.255.253.241"
master_ips = ["10.255.253.242", "10.255.253.243", "10.255.253.244"]
#worker_ips = ["192.168.5.164", "192.168.5.165"]
worker_ips = ["10.255.253.245", "10.255.253.246", "10.255.253.247"]
## Cluster configuration
vmware_folder = ""
rhcos_template = "Template-RHCOS"
#cluster_slug = "ok"
cluster_domain = "devops.lan"
machine_cidr = "10.255.253.224/27"
netmask ="255.255.255.224"

## DNS
local_dns = "10.255.253.10" # probably the same as coredns_ip
public_dns = "8.8.8.8" # e.g. 1.1.1.1
gateway = "10.255.253.254"
## Ignition paths
## Expects `openshift-install create ignition-configs` to have been run
bootstrap_ignition_path = "/root/ocptest/bootstrap.ign"
master_ignition_path = "/root/ocptest/master.ign"
worker_ignition_path = "/root/ocptest/worker.ign"
