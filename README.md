# Hashicorp Nomad, Consul, and Vault

### Why run containers on Hashicorp code?  

Nomadic is a Terraform framework to deploy Hashicorp minimal and secure container clusters.  Hashicorp ensures your dockers are up and running (fail-over for fault tolerance), and running securely (secrets rotation and aws security). The internet is a dangerous place. Warship Not Whale.


### Nomadic Framework

1. Terraform IaC provisioning of cluster resources.
2. Optional VPC creation (incl. associated VPC resources).
3. Server bootstrapping via Ansible and cloud-init.
4. Consul provides container application registration.
5. Vault provides container application secrets.
6. Nomad provides container application scheduling.

Nomadic Terraform code deploys a (3) node EC2 instance cluster to implement the minimal deployment footprint possible to support running containers on Hashicorp code. The following services run on each Nomadic cluster node:

  1. Vault server (one instance in primary, two in standby)
  2. Consul server
  3. Nomad server
  4. Consul client
  5. Nomad client.

All these services run on each EC2 instance cluster node. Auto-scaling allows the cluster clients to scale out, as needed by load. By default, Nomadic deploys all these services on (3) EC2 servers only. Nomad and Consul use raft and EC2 autodiscovery for cluster convergence.





### Nomadic Deployment

Deploying the cluster

1. set variables in `terraform.tfvars`

2. `terraform apply`




### Nomadic Pilgrims and Pilgrim Pipelines

Pilgrims are a collection of resources that make up an application, including the pipeline necessary for application updates. Each application is a unique pilgrim, on a unique journey. Codepipeline runs a pipeline for each application. Pilgrim pipelines can run idempotently many times, updating on any application change, if needed.  Pilgrim pipeline unit and integration testing finds breaking changes before code makes it to production, ensuring high change success confidence. Pilgrim Applications can be effortlessly updated dozens, even hundreds, of times a day.

Each Pilgrim Application contains the following resources:

1. EFS volume created and configured, including Route53 DNS entry.

2. ELB frontend created and configured, including Route53 DNS entry.

3. Codepipeline Pipeline creation and/or execution.
  - Deploy / Update Nomad task job 
  - Security and Acceptance post-deployment test stages


### Pilgrim Deployment

To deploy Nomadic Pilgrim pipelines, use the `pilgrims` directory as a template for your pilgrim application. There should be a unique directory per application. You will need to configure this template for your specific application. Once configured, `terraform apply` in this directory. This will create the CodePipeline pipeline, and the EFS and ELB resources required for your application.  The pipeline will deploy and/or update the pilgrim application by updating the Nomad job.

As each pilgrim is just a collection of Terraform resources, advanced users can use Terraform Remote State to manage Nomadic Pilgrims, as opposed to maintaining an application deployment directory.
