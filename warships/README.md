# Warship Shared Resources

### Each application, or Warship, has a unique journey and lifecycle.
- The terraform resources in this directory are shared amongst all the warship application pipelines. 
- Docker directory `nomadic_application_example`. This directory contains application Dockerfile and supporting files.
- Terraform template directory `skeleton`. This example directory is used to deploy Warship Pipelines (CodePipelines).

###To create a Warship Application (container image, pipeline, and deployment):
1. Deploy the shared resources (S3 and IAM).
   1. Update `terraform.tfvars` in this directory as needed.
   2. Execute `terraform init` and `terraform apply` in this existing directory.
   3. Shared resources are published to SSM ParameterStore for pipeline usage.
2. Deploy the individual warships (application pipelines)
   1. Copy the `skeleton` directory to a unique application directory name.
   2. Update `terraform.tfvars` in this directory as needed.
   3. Execute `terraform init` and `terraform apply` in this new directory.
   4. CodePipeline application warship pipeline is created and executed.
      1. Application should now be live on the Nomadic Cluster.
      2. Container should be running on Nomad
      3. Container registration should be visible in Consul
3. The Application Load Balancer and DNS configured and added to route53. (Optional)
4. The EFS mount created and available to running containers for shared filesystem state (Optional).
