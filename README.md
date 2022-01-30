# Hashicorp Nomad, Consul, and Vault

### Why run containers on Hashicorp code?  

Nomadic is a Terraform framework to deploy Hashicorp minimal and secure container clusters.  Hashicorp ensures your dockers are up and running (fail-over for fault tolerance), and running securely (secrets rotation and AWS security). The Internet is a dangerous place. **Warship Not Whale**.


### Nomadic Framework

1. Terraform IaC provisioning of cluster resources.
2. Optional VPC and supporting resource creation.
3. Server bootstrapping via Instance UserData.
4. Consul provides application container registration.
5. Vault provides application container secrets.
6. Nomad provides application container scheduling.

Nomadic Terraform code deploys a (3) node EC2 instance cluster to implement the minimal deployment footprint possible to support running containers on Hashicorp code. The following services run on each Nomadic cluster node:

1. Vault server (one instance in primary, two in standby).
  1. Vault API tcp/8200

2. Consul server.
  1. DNS: The DNS server (TCP and UDP) 8600
  2. HTTP: The HTTP API (TCP Only) 8500
  3. HTTPS: The HTTPs API (disabled) 8501
  4. gRPC: The gRPC API	(disabled) 8502
  5. LAN Serf: The Serf LAN port (TCP and UDP) 8301
  6. Wan Serf: The Serf WAN port (TCP and UDP) 8302
  7. server: Server RPC address (TCP Only) 8300

3. Nomad server.
  1. HTTP API tcp/4646
  2. RPC tcp/4647
  3. Serf WAN tcp/4648

Nomadic deploys all of these services on each of the (3) EC2 cluster instances.
- Nomad and Consul use the Raft protocol and EC2 autodiscovery for cluster convergence.
- Consul reads a common encryption token from SSM Parameter.
- Vault uses KMS auto-unsealing.
- Vault uses one-active/two-standy design.
- Consul and Nomad use three active node design (shared cluster state).


### Nomadic Deployment

Deploying the cluster:

1. set variables in `terraform.tfvars`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`


### Nomadic Pilgrims and Pilgrim Pipelines

Pilgrims are a collection of resources that make up an application, including the pipeline necessary for application updates. CodePipeline runs a unique pipeline for each application. Pilgrim pipelines can run idempotently many times, updating on any application change, only if needed. Pilgrim pipeline unit and integration testing finds breaking changes before code makes it to production, ensuring high change success confidence. Pilgrim Applications can be effortlessly updated dozens, even hundreds or thousands of times a day. **Each Application is a Unique Pilgrim, on a Unique Journey**.

Each Pilgrim Application contains the following resources:

1. EFS volume created and configured, including Route53 DNS entry.
2. ELB frontend created and configured, including Route53 DNS entry.
3. CodePipeline pipeline:
   1. Unit and Integration pre-deployment test stages
   2. Deploy and/or Update Dockers via Nomad API
   3. Security and Acceptance post-deployment test stages


### Pilgrim Deployment

To deploy Nomadic Pilgrim pipelines, use the `pilgrims` directory as a template for your pilgrim application directory. There should be a unique directory per application. You will need to configure this template for your specific application. Once configured, execute `terraform init` and `terraform apply` in this directory. This will create the CodePipeline pipeline, and the EFS and ELB resources required for your application.  The pipeline will deploy and/or update the pilgrim application by updating the Nomad job.

As each pilgrim is just a collection of Terraform resources, advanced users can use Terraform Remote State to manage Nomadic Pilgrims, as opposed to maintaining an application deployment directory.


### Pre-deployment Configuration

The following AWS SSM Parameter Store keys must be set before executing Nomadic deployment:
1. `consul_encryption_key` This key is read by all consul nodes and is needed for Consul cluster quorum.
2. `nomadic_ssh_key` This key is used for intercluster communications, and also for Pilgrim pipelines to execute application changes.

Additionally, care must be taken to ensure variables in `terraform.tfvars` are set properly, according to user environment. By default, each Nomadic cluster node will be deployed in a separate subnet and availability zone.  Users can deploy into existing VPCs/Subnets by specifying values here.


### Nomadic Support

Nomadic support is available `nomadic at hex7 dot com`.

### Warship Not Whale.
![alt text](https://github.com/nand0p/nomadic/blob/master/images/nomadic.png?raw=true)
