## HTTP
```
kubectl apply -f .
```
- you create ingress with TLS session, cert-manager immediately create a certificate custom resource placeholder
```
kubectl get certificate
kubectl get secret
```

- cert-manager same time generate private key, that will be stored in a kubernetes  secret. The certificate custom resource will simply have a reference to that secret.

```
kubectl get secret <secretname> -o yaml
```
