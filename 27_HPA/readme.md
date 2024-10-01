## HPA
- increase or decrease the number of Relicas (PODS)
- automatically scales the number of pods in a deployment, replication controller or replica set, stateful set based on the resources CPU utilization or custom metrics
- help our application scale out to meet increase demand or scale in when resources are not needed.
- HPA needs K8s metrics server to verify CPU metrics of Pod

## steps:

-    need to configure metric server
-    horizontal pod autoscaler configure require metrics, from metric server using Query for metrics
-    HPA calculate the replicas
-    HPA scale the app to desire replicas in Deploy, RS or statefulset


## HPA configuration:
    Scaling Metrics: CPU Utilization
    Target Value: CPU:50%
    Min Replicas: 2
    Max Replicas: 10
```shell
$ kubectl autoscale deployment demo-deployment --cpu-percentage=50 --min=1 --max=10
```

## Install Metrics Server:
```shell
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/release/download/v.0.3.6/components.yaml
```

## verify metrics server
```shell
$ kubectl get deployment metrics-server -n kube-system
```
------------------------------------------------------------------------------------------
## 1. create deployment
```
$ kubectl apply -f 27_HPA/hap_deployment.yaml
```
## 2. apply HAP using command
```shell
$ kubectl autoscale deployment hpa-demo-deployment --cpu-percent=50 --min=1 --max=10
```
## 3. check the staus
```shell
$ kubectl describe hpa/hpa-demo-deployment
```
## 4. list the hpa status
```shell
$ kubectl get horizontalpodautoscaler.autoscaling/hpa-demo-deployment
```
## 5. generate load 
```shell
$ kubectl run --generate=run-pod/v1 apache-bench -i --tty --rm --image=httpd -- ab -n 50000 -c 1000 http://hpa-demo-service-nginx.default.svc.cluster.local/
```

## 6. 
 ```
$ kubectl top node
$ kubectl top
```
