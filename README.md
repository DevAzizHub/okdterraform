Ce dépôt contient du code pour déployer OpenShift 4 dans mon laboratoire domestique. Il se concentre sur l'approche UPI avec vSphere 6.7u3, et un guide détaillé est disponible sur openshift.com.

Mai 2021 - Le code présent ici fonctionne avec la version 4.7.

Prérequis
Sur un Mac, vous devrez installer quelques paquets via brew.

bash
Copier le code
brew install jq watch gsed
Utilisation
Le code pour chaque version d'OpenShift vit sur une branche numérotée. La branche master représente la dernière itération stable et sera probablement en retard par rapport aux autres branches. En d'autres termes, vérifiez d'abord les branches numérotées avant de regarder master.

Ce dépôt nécessite Terraform 0.13 ou une version ultérieure.
Installez les outils oc avec ./install-oc-tools.sh --latest 4.6
Ce code utilise yamldecode - détails disponibles ici
Créez ~/.config/ocp/vsphere.yaml pour utiliser yamldecode, avec un contenu d'exemple :
yaml
Copier le code
vsphere-user: administrator@vsphere.local
vsphere-password: "123!"
vsphere-server: 192.168.1.240
vsphere-dc: ktzdc
vsphere-cluster: ktzcluster
Configurez DNS - https://blog.ktz.me/configure-unbound-dns-for-openshift-4/ - si vous utilisez CoreDNS, c'est optionnel.
Créez install-config.yaml et assurez-vous que cluster_slug correspond à metadata: name: ci-dessous.
yaml
Copier le code
apiVersion: v1
baseDomain: openshift.lab.int
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ocp4
platform:
  vsphere:
    vcenter: 192.168.1.240
    username: administrator@vsphere.local
    password: supersecretpassword
    datacenter: ktzdc
    defaultDatastore: nvme
fips: false
pullSecret: 'VOTRE_PULL_SECRET'
sshKey: 'VOTRE_CLÉ_SSH_PUBLIQUE'
Personnalisez clusters/lab/terraform.tfvars avec toute configuration pertinente.

Exécutez make tfinit pour initialiser les modules Terraform.

Exécutez make lab pour créer les VMs et générer/installer les configurations Ignition.

Surveillez la progression de l'installation avec make wait-for-bootstrap.

Vérifiez et approuvez les CSR en attente avec make get-csr et make approve-csr.

Exécutez make bootstrap-complete pour détruire la VM bootstrap.

Exécutez make wait-for-install et attendez la fin de l'installation du cluster.

Profitez !

Ces instructions détaillent le processus pour déployer OpenShift 4 sur vSphere en utilisant l'approche UPI, en vous guidant à travers les étapes nécessaires depuis la configuration initiale jusqu'à l'achèvement de l'installation.
