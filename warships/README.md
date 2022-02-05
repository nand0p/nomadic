# Warship Application Pipelines

Each application, or Warship, has a unique journey and lifecycle.
1. Docker directory `container`. This directory contains application Dockerfile and supporting files.
2. Terraform template directory `skeleton`. This example directory is used to deploy Warship Pipelines.

To create a Warship Application (container image, pipeline, and deployment):
1. Copy the `skeleton` directory to a unique application directory name.
2. update Terraform variables as needed.
3. Execute `terraform init` and `terraform apply` to create pipeline resources.
4. Warship Pipeline Execution. This runs the CodePipeline which deploys application to Nomadic Cluster.
5. The Application Load Balancer DNS configured and added to route53. (Optional)
6. The EFS mount created and available to running container for shared filesystem state (Optional).
