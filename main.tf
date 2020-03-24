resource "kubernetes_ingress" "add_ingress" {
  metadata {
    name = var.app_name
    namespace = var.app_namespace
    annotations = var.annotations
  }
  spec {
    dynamic "rule" {
      iterator = web_port
      for_each = var.web_internal_port
      content {
        host = "${lookup(web_port.value, "sub_domain", "")}${var.domain_name}"
        http {
          path {
            path = lookup(web_port.value, "path", null)
            backend {
              service_name = var.app_name
              service_port = web_port.value.internal_port
            }
          }
        }
      }
    }
    dynamic "tls" {
      for_each = var.tls
      content {
        secret_name = tls.value.tls
      }
    }
  }
}