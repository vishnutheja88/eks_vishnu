resource "aws_iam_role" "eks_role" {
  name               = "${local.env}-${local.eks_name}-eks-cluster"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssuemRole",
            "Principal": {
                "Service": "eks.amazon.com"
            }
        }
    ]
}
POLICY
}

# eks cluster policy
resource "aws_iam_role_policy_attachment" "eks_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmzaonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# eks cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.env}-${local.eks_name}"
  version  = local.eks_version
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids              = [aws_subnet.public_zone1.id, aws_subnet.public_zone2.id]
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks_policy_attach]
}
# nodegroup for eks cluster
## iam role
resource "aws_iam_role" "node_group" {
    name = "${local.env}-${local.eks_name}-eks-nodes"
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Prinicipal": {
                "Service": "ec2.amazon.com"
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_group.name
}
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_group.name
}

    # nodegroup
resource "aws_eks_node_group" "eks_node_group_general" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    node_role_arn = aws_iam_role.node_group.arn
    version = local.eks_version
    subnet_ids = [aws_subnet.public_zone1, aws_subnet.public_zone2 ]
    capacity_type = "ON_DEMAND"
    instance_types = [ "t3.medium" ]

    scaling_config {
        desired_size = 1
        max_size = 4
        min_size = 0
    }
    update_config {
      max_unavailable = 1
    }
    labels = {
      "role" = "general"
    }
    depends_on = [ aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
                    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
                    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
                    aws_iam_role_policy_attachment.eks_policy_attach]              
    lifecycle {
      ignore_changes = [ scaling_config[0].desired_size ]
    }
}