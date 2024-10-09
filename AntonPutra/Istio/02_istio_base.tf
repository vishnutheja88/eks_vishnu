# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install my-istio-base-release -n istio-system --cretate-namespace istio/base --set global.istioNamespace=istio

resource "helm_release" "isto_base" {
  name = "my-istio-base-release"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "base"
  namespace = "istio-system"
  create_namespace = true
  version = "1.17.1"
  set {
    name = "global.Namespace"
    value = "istio-system"
  }
}
