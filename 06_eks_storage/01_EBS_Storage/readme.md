CSI: Container Storage Interface
    In-Tree EBS Provisioner
        Legacy
        will be deprecated soon
    EBS CSI Driver
    EFS CSI Driver
    FSx for Luxter CSI

1. create IAM policy for EBS
2. Associate IAM policy to workernode IAM roles
3. Install EBS CSI drivers


STEP 1:
create a policy> name: Amazon_EBS_CSI_Drvier
                Description: policy of EC2 Instances to access Elastic Block Store for EKS Service
                Create Policy

STEP 2:
# get worker node IAM role ARN
$ kubectl describe configmap aws-auth -n kube-system | grep -i rolearn 
    or
goto eks nodes > check the IAM role for ec2 worker nodes.

iam > roles > select role and attach Amazon_EBS_CSI_Driver policy

STEP 3:
$ kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

$ kubectl ger pods -n kube-system
    ebs-csi-controller-xxxxxx
    ebs-csi-node-xxxx



