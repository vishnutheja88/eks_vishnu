

## iam users add to eks cluster
- AWS side we can use IAM users or IAM roles as object that represent the identities
- On kuberntes, for the identities we can user kuberntes services, account, users and RBAC groups.
- We'll map IAM user and IAM role to custom RBAC groups that would have different permissions.


# steps for IAM user
- create IAM user attache policy having DescribeCluster and ListClusters actions. 
- EKS create ClusterRole having resources: deploy, configmaps, pods, secrets, services and verbs: get, list, watch
- Create ClusterRoleBind attach 
# steps for IAM Role
- IAM role attach policy having assume eks.amazonaws.com
- eks side we configured permissions using ClusterRoleBinding and ClusterRole Objects
- IAM user having policy assume above create IAM role 


# steps for manager Admin Kubernetes user

```
aws configure --profile manager
aws sts assume-role --role-arn arn:aws:iam::<awsaccountid>:role/staging-demo-eks-admin --role-session-name manager-session --profile manager
```
- create another aws profile for tempoparly manager credentials like accesskey, secretkey and sessiontoken
```
~ vim ~/.aws/config
[profile eks-admin]
role_arn = arn:aws:iam::<accountid>:role/staging-demo-eks-admin
source_profile = manager

aws eks update-kubeconfig --region us-east-1 --name staging-demo --profile eks-admin
kubectl config view --minify
#check the profile you are using
kubectl auth can-i "*" "*"
```

