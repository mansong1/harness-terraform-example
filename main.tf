terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

locals {
  name_suffix = "mansong"
}

provider "harness" {
  endpoint         = var.endpoint
  account_id       = var.account_id
  platform_api_key = var.platform_api_key
}

resource "harness_platform_project" "helm" {
  name       = "helm-${local.name_suffix}"
  identifier = "helm_${local.name_suffix}"
  org_id     = var.org_id
  color      = "#15098f"
}

resource "harness_platform_connector_kubernetes" "kubernetes" {
  identifier  = "GKE"
  name        = "GKE"
  description = ""
  tags        = ["cloud:gcp"]
  org_id      = var.org_id
  project_id  = harness_platform_project.helm.id

  inherit_from_delegate {
    delegate_selectors = ["literate-octo-broccoli", "gkedelegate"]
  }
}

resource "harness_platform_connector_helm" "bitnami" {
  name       = "Bitnami"
  identifier = "Bitnami"
  org_id     = var.org_id
  project_id = harness_platform_project.helm.id
  url        = "https://charts.bitnami.com/"
}

resource "harness_platform_service" "service" {
  name       = "nginx"
  identifier = "nginx"
  org_id     = var.org_id
  project_id = harness_platform_project.helm.id
}

resource "harness_platform_environment" "environment" {
  name       = "dev-${local.name_suffix}"
  identifier = "dev_${local.name_suffix}"
  org_id     = var.org_id
  project_id = harness_platform_project.helm.id
  type       = "PreProduction"
}

resource "harness_platform_pipeline" "nginx" {
  name       = "nginx"
  identifier = "nginx"
  org_id     = var.org_id
  project_id = harness_platform_project.helm.id
  yaml = templatefile("pipelines/nginx.yaml.tpl", {
    org_id            = var.org_id,
    project_id        = "${harness_platform_project.helm.id}",
    bitname_connector = "${harness_platform_connector_helm.bitnami.id}",
    environment_id    = "${harness_platform_environment.environment.id}",
    service_id        = "${harness_platform_service.service.id}",
    kubernetes_connector = "${harness_platform_connector_kubernetes.kubernetes.id}" }
  )
  depends_on = [
    "harness_platform_environment.environment",
  ]
}


