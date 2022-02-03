resource "aws_codepipeline" "nomadic_pipeline" {
  name     = var.app_name
  role_arn = aws_iam_role.nomadic_pipeline.arn

  artifact_store {
    location = aws_s3_bucket.nomadic_pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "nomadic_pipeline_source"
    action {
      name             = "nomadic_pipeline_source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = [ "source_output" ]
      configuration = {
        RepositoryName = var.app_name
        BranchName     = "master"
      }
    }
  }
  
  stage {
    name = "nomadic_pipeline_deploy"
    action {
      name             = "${var.app_name}_deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = [ "source_output" ]
      output_artifacts = [ "nomadic_deploy" ]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.nomadic_deploy.name
        EnvironmentVariables = jsonencode([
          { "name"="ENVIRONMENT", "type"="PLAINTEXT", "value"=var.environment },
          { "name"="APP_NAME", "type"="PLAINTEXT", "value"=var.app_name },
          { "name"="AWS_REGION", "type"="PLAINTEXT", "value"=var.aws_region },
          { "name"="SSH_KEY", "type"="PLAINTEXT", "value"=data.aws_ssm_parameter.nomadic_ssh_key.value },
          { "name"="SECGROUP_ID", "type"="PLAINTEXT", "value"=data.aws_ssm_parameter.nomadic_security_group_id.value },
          { "name"="NOMADIC_LEADER", "type"="PLAINTEXT", "value"=split(",",data.aws_ssm_parameter.nomadic_instances.value)[0] },
        ])
      }
    }
  }
}

resource "aws_s3_bucket" "nomadic_pipeline" {
  bucket        = "nomadic-pipeline"
  acl           = "private"
  force_destroy = true
}


resource "aws_codebuild_project" "nomadic_deploy" {
  name          = "${var.app_name}_deploy"
  description   = "${var.app_name}_deploy"
  build_timeout = "15"
  service_role  = aws_iam_role.nomadic_pipeline.arn

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
      group_name  = var.app_name
      stream_name = "deploy"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "pilgrims/${var.app_name}/buildspec/deploy.yml"
  }

  tags = local.tags
}
