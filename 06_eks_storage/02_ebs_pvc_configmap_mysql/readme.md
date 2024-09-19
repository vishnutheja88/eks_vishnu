 1. storageclass
 2. persistence volume claim
 3. user management configmap
 4. mysql deployment
 5. mysql clusterip service
 
 $ kubectl apply -f 01 and 02 files
 $ kubectl get sc
 $ kubectl get pvc

 $ kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -p dbpassword11

 mysql> show schemas;
 