## DNS

- you need to integrate your Cert-Manager with cloud DNS (Route53).
- we need to use OpenID Connect provider and create dedicate IAM role to be used by cert-manager k8s service account.

```
kubectl apply -f .
```

```
kubectl get certificate
kubectl get challange
kubectl get ing
```
- create a record in route53 using ingress LB.
- open the dns.vishnuthejabhari.xyz on the browser.

