# Each warship (application pipeline) has a unique set of the
# following skeleton resources below:


resource "aws_codepipeline" "nomadic_warship_skeleton" {
  name     = "nomadic-warship-${var.app_name}"
  role_arn = data.aws_ssm_parameter.warship_pipelines_iam_role_arn.value

  artifact_store {
    location = data.aws_ssm_parameter.warship_pipelines_s3.value
    type     = "S3"
  }

  stage {
    name = "nomadic_warship_${var.app_name}_source"
    action {
      name             = "nomadic_warship_${var.app_name}_source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = "nomadic"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "nomadic_warship_${var.app_name}_deploy"
    action {
      name             = "nomadic_warship_${var.app_name}_deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["nomadic_deploy"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.nomadic_warship_skeleton_deploy.name
        EnvironmentVariables = jsonencode([
          { "name" = "ENVIRONMENT", "type" = "PLAINTEXT", "value" = var.environment },
          { "name" = "APP_NAME", "type" = "PLAINTEXT", "value" = var.app_name },
          { "name" = "AWS_REGION", "type" = "PLAINTEXT", "value" = var.aws_region },
          { "name" = "SECGROUP_ID", "type" = "PLAINTEXT", "value" = data.aws_ssm_parameter.nomadic_security_group_id.value },
        ])
      }
    }
  }
}

resource "aws_codebuild_project" "nomadic_warship_skeleton_deploy" {
  name          = "nomadic-warship-${var.app_name}_deploy"
  description   = "nomadic-warship-${var.app_name}_deploy"
  build_timeout = "10"
  service_role  = data.aws_ssm_parameter.warship_pipelines_iam_role_arn.value

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "nomadic-warship-${var.app_name}"
      stream_name = "deploy"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "warships/${var.app_name}/buildspec/deploy.yml"
  }

  tags = local.tags
}
