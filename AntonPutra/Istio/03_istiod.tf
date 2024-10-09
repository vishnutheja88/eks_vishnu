# helm repo add https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install my-istiod-release -n istio-system --create-namespace istio/istiod --set telemetry.enabled=true --set gobal.istioNamespace=istio-system --set meshConfig.ingressService=istio-gatway --set meshConfig.ingressSelector=gateway

resource "helm_release" "istiod" {
  name = "my-istiod-release"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"
  namespace = "istio-system"
  create_namespace = true
  version = "1.17.1"

  set {
    name = "telemetry.enabled"
    value = true
  }
  set {
    name = "global.istioNamespace"
    value = "istio-system"
  }
  set {
    name = "meshConfig.ingressService"
    value = "istio-gateway"
  }
  set {
    name = "meshConfig.ingressSelector"
    value = "gateway"
  }
  depends_on = [ helm_release.isto_base ]
}