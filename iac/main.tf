terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
  #"dop_v1_654c11370400b80bfef5e17a575e18d545efa451b1f7bae994dad980572cba50"
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name = var.k8s_name #"k8s-iniciativa-devops"
  region = var.region #"nyc1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 3

  } 
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id
  name       = "premium"
  size       = "s-4vcpu-8gb"
  node_count = 2
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
  
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
  filename = "kube_config.yaml"
}