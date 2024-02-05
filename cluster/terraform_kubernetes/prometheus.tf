resource "kubernetes_cluster_role" "prometheus" {

  metadata {
    name = "prometheus"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods", ]
    verbs      = ["get", "list", "watch", ]
  }

  rule {
    api_groups = ["extensions", ]
    resources  = ["ingresses", ]
    verbs      = ["get", "list", "watch", ]
  }

  rule {
    non_resource_urls = ["/metrics", ]
    verbs             = ["get", ]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus" {

  metadata {
    name = "prometheus"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "monitoring"
  }

}

resource "kubernetes_config_map" "prometheus" {

  metadata {
    name      = "prometheus-server-conf"
    namespace = "monitoring"
  }

  data = {
    "prometheus.rules" = "${file("${path.module}/config/prometheus/${var.config}.prometheus.rules")}"
    "prometheus.yml"   = "${file("${path.module}/config/prometheus/${var.config}.prometheus.yml")}"
  }

}

resource "kubernetes_deployment" "prometheus" {

  metadata {
    name      = "prometheus"
    namespace = "monitoring"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus-server"
        }
      }

      spec {
        container {
          image = "prom/prometheus:${var.prometheus_version}"
          name  = "prometheus"

          args = [
            "--storage.tsdb.retention.time=${var.prometheus_tsdb_retention_time}",
            "--config.file=/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path=/prometheus/",
          ]

          port {
            container_port = 9090
          }

          resources {
            limits = {
              cpu    = 1
              memory = var.prometheus_app_mem
            }
            requests = {
              cpu    = "500m"
              memory = "500M"
            }
          }

          volume_mount {
            mount_path = "/etc/prometheus/"
            name       = "prometheus-config-volume"
          }

          volume_mount {
            mount_path = "/prometheus/"
            name       = "prometheus-storage-volume"
          }
        }

        volume {
          name = "prometheus-config-volume"
          config_map {
            #              default_mode = "0420"
            name = kubernetes_config_map.prometheus.metadata[0].name
          }
        }

        volume {
          name = "prometheus-storage-volume"
          empty_dir {}
        }

      }
    }
  }
}

resource "kubernetes_service" "prometheus" {

  metadata {
    name      = "prometheus"
    namespace = "monitoring"
    annotations = {
      "prometheus.io/port"   = "9090"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      node_port   = 30000
      port        = 8080
      target_port = kubernetes_deployment.prometheus.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
    selector = {
      app = "prometheus-server"
    }
    type = "NodePort"
  }
}
