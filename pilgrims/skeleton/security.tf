resource "aws_iam_role" "nomadic_pipeline" {
  name_prefix        = var.app_name
  assume_role_policy = data.aws_iam_policy_document.nomadic_pipeline_assume_role.json
  path               = "/"
  tags               = { Name = var.app_name }
}

data "aws_iam_policy_document" "nomadic_pipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [ "ec2.amazonaws.com", "codepipeline.amazonaws.com", "codebuild.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role_policy" "nomadic_pipeline" {
  name_prefix = var.app_name
  policy      = data.aws_iam_policy_document.nomadic_pipeline.json
  role        = aws_iam_role.nomadic_pipeline.id
}

data "aws_iam_policy_document" "nomadic_pipeline" {
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
    resources = [ "*" ]
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
      aws_s3_bucket.nomadic_pipeline.arn,
      "${aws_s3_bucket.nomadic_pipeline.arn}/*"
    ]
  }
}
