# These resources are shared by all application warship pipelines

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "warship_pipelines" {
  name_prefix        = "nomadic-warship-pipelines-"
  assume_role_policy = data.aws_iam_policy_document.warship_pipelines_assume_role.json
  path               = "/"
  tags               = { Name = "nomadic-warship-pipelines" }
}

data "aws_iam_policy_document" "warship_pipelines_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "codepipeline.amazonaws.com", "codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "warship_pipelines" {
  name_prefix = "nomadic-warship-pipelines-"
  policy      = data.aws_iam_policy_document.warship_pipelines.json
  role        = aws_iam_role.warship_pipelines.id
}

data "aws_iam_policy_document" "warship_pipelines" {
  statement {
    sid = "1"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive",
      "iam:PassRole",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetInstanceProfile",
      "iam:CreateRole",
      "iam:CreateRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteInstanceProfile",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:TagRole",
      "iam:AddRoleToInstanceProfile",
      "route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"]
  }

  statement {
    sid = "2"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.warship_pipelines.arn,
      "${aws_s3_bucket.warship_pipelines.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "warship_pipelines" {
  bucket_prefix = "nomadic-warship-pipelines-"
  acl           = "private"
  force_destroy = true
}

resource "aws_ssm_parameter" "warship_pipelines_s3" {
  name      = "warship_pipelines_s3"
  type      = "String"
  overwrite = true
  value     = aws_s3_bucket.warship_pipelines.id
}

resource "aws_ssm_parameter" "warship_pipelines_iam_role_arn" {
  name      = "warship_pipelines_iam_role_arn"
  type      = "String"
  overwrite = true
  value     = aws_iam_role.warship_pipelines.arn
}
