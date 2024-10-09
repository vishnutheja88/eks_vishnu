## ISTIO SERVICE MESH ON AWS

- for installation istio operator was deprciated most of prefered using helm charts for configure istio in k8s.
- istioctl can manage istio

# Helm commands
```
helm search repo istio/base
```
```
helm show values istio/base --version 1.17.1 > helm-defaults/istio-base-default.yaml
```

## install istio using terraform following commands
```
terraform init
terraform plan
terraform apply
```
```
kubectl get pods -n kube-system
    Name: istiod-xxxxx
kubectl get crds | grep -i "istio.io"
```

## example-1
```
kubectl apply -f example-1/*
kubectl exec -it client -n backend -- sh
    $ while true; do curl http://first-app.staging:8080/api/devices && echo "" && sleep 1; done
```
- traffic only routed to the v1 container
- now change traffic to v2 using change subset: v2 in the VirtualService defination file.
- then uncomment the commented lines using for canary deployment. In this scenario we will gradually increased the traffice v1 90% and v2 10%.
```
kubectl exec -it client -n backend -- sh
    $ while true; do curl http://first-app.staging:8080/api/devices && echo "" && sleep 1; done
```


## inject side cars into the pods
# example-2
- 1. using label in the namespace istio-injection: enabled 
- 2. using label in the deployment sidecar.istio.io/inject: true
- 3. inject manually

## Gateway
- you want to expose an application running in the k8s cluster using istio ingress gateway
- save the default value of helm chart using following command
```
helm show valude istio/gateway --version 1.17.1 > helm-defaults/gateway-default.yaml
```
```
# create file 04_istio_gateway.tf
terraform apply 
```
