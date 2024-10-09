# helm repo update
# helm install gateway -n istio-ingress --create-namespace istio/gateway

resource "helm_release" "gateway" {
  name = "gateway"
  repository = "https://istio-release.storage.googleapis.io/charts"
  chart = "gateway"
  namespace = "istio-ingress"
  create_namespace = true
  version = "1.17.1"

  depends_on = [ helm_release.istiod, helm_release.isto_base ]
}