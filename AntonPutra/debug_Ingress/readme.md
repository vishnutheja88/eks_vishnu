- data between load balancer and client by using encryption to prevent man in middle attack
- where as unauthorized entity can intercept every single packet that you send to the server.
## Secure Website using TLS
- to encrypt the traffic we need to get a certificate from a well known trusted certificate authority(let's encrypt).
- the trust is established by installing a root certificate from the CA, such as Let's Encrypt. 

## 

- to issue certificate first you need to generate a private key and certificate request. Then you send the certificate request to certificate authority such as Let's Encrypt to have it signed. 
- the certificate authority would ask you to prove that you actually own that domain. To verfiy using Email, HTTP-01 and DNS-01

## HTTP
- user send request to website: then user send request to let's encrypt asks I need certificate for example.com
- then let's encrypt gives you a token which you need to expose on your website .
- website by following a specific pattern, let's encrypt would try to retrieve that specific token back from user multiple times, if it success. 
- it will sign your certificate request and issue certificate (public).

## DNS
- let's encrypt will give you the same token, but you will need to create a TXT DNS record to prove that you control you domain in Route53.
- when let's encrypt is able to query DNS and retrive the token, they will issue a certificate. 

## Cert-Manger Workflow

- If you want to get certificates for Kubernetes, most of time you would user cert-manager.
- when you create an ingress and specify the TLS section, cert-manager will create a certificate custom resource and generate private key that will stored in the secret.
- the Cert-Manager will create CertificateRequest to custom resource, the certificate request will be stored in the custom resource itself since it's public.
- The CertificateRequest will create an order, and finally, the order will create a challenge. The challenge can be either HTTP or DNS type.
- The challenge is resolved, cert-manger will receive a public certificate and store it in the same kubernetes secret with the private key. The certificate will be valid for 90 days. 