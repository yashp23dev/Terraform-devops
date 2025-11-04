resource "aws_eks_cluster" "aws_eks" {
  name     = "eks_cluster_demo"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
  
    tags = {
        Name = "eks_cluster_demo"
    }

}

resource "aws_eks_node_group" "eks_nodes" {
  
    cluster_name    = aws_eks_cluster.aws_eks.name
    node_group_name = "eks_nodes_demo"
    node_role_arn   = aws_iam_role.eks_nodes.arn
    subnet_ids      = module.vpc.public_subnets
    
    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }
    
    # Ensure that IAM roles are created before the node group and deleted after EKS Node Group handles deletion
    # Otherwise, EKS Node Group creation/deletion may fail due to missing IAM roles
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}