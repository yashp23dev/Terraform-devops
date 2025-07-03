#TF file for IAM users and groups

resource "aws_iam_user" "user1" {
    name = "user1"    
}

resource "aws_iam_user" "user2" {
    name = "user2"
}

# Group for IAM users

resource "aws_iam_group" "group1" {
    name = "group1"
}

# Attach IAM users to the group

resource "aws_iam_user_group_membership" "admin-users" {
    user = aws_iam_user.user1.name
    groups = [aws_iam_group.group1.name]
}

resource "aws_iam_user_group_membership" "dev-users" {
    user = aws_iam_user.user2.name
    groups = [aws_iam_group.group1.name]
}

# IAM policy for the group

resource "aws_iam_policy_attachment" "group1-policy" {
    name       = "group1-policy"
    groups     = [aws_iam_group.group1.name]
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}