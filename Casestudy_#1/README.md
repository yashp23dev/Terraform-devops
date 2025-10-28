# End to End Appicatio Deployment on AWS

> 🚀 Complete Terraform-based deployment for a sample web application (VPC → RDS → Webservers behind ALB)

---

## Project overview

This repository contains a small end-to-end Terraform project that builds:
- A custom VPC with public and private subnets.
- An RDS (MySQL) instance in the private subnets.
- An Auto Scaling webserver fleet (user-data provisioning) and an Application Load Balancer.

It is structured as a module for reusable infra components and a `webserver` top-level configuration that consumes those modules.

## Directory structure 🗂️

```
/Terraform/Casestudy_#1
├─ main.tf                # (optional) root entrypoint — check module sources
├─ variable.tf            # (optional) root-level variables
├─ module/ 🚧
│  ├─ vpc/ 🛰️
│  │  ├─ vpc.tf            # VPC, subnets, IGW, NAT, route tables, outputs
│  │  └─ variable.tf       # VPC variables and defaults
│  └─ rds/ 🗄️
│     ├─ rds.tf            # RDS subnet group, SG, aws_db_instance, outputs
│     └─ variable.tf       # RDS variables and defaults

├─ webserver/ 🌐
│  ├─ webserver_instance.tf # Modules usage, ASG, launch configuration, keypair
│  ├─ webserver_alb.tf      # ALB security group
│  ├─ variable.tf           # Webserver variables (AMIs, SSH_CIDR, keys)
│  └─ user_data.sh          # Instance user-data: installs nginx and writes index.html

└─ README.md 📘 (this file)
```

> Note: `webserver` is the top-level Terraform configuration that calls modules in `../module/*`.

## Quick file-by-file description 🔍

- `module/vpc/vpc.tf` — defines:
  - VPC (`aws_vpc`) with CIDR from `LEVELUP_VPC_CIDR_BLOCK`.
  - Two public and two private subnets across availability zones.
  - Internet Gateway and NAT Gateway (EIP + NAT) for private subnet egress.
  - Route tables and associations.
  - Outputs: `my_vpc_id`, `private_subnet1_id`, `private_subnet2_id`, `public_subnet1_id`, `public_subnet2_id`.

- `module/vpc/variable.tf` — variables and defaults (region, CIDR blocks, environment name).

- `module/rds/rds.tf` — defines:
  - `aws_db_subnet_group` using private subnet IDs from the VPC module.
  - An RDS `aws_db_instance` configured with engine, storage, username/password, security group.
  - Security Group allows MySQL (port 3306) from `var.RDS_CIDR`.
  - Output: `rds_prod_endpoint` (RDS endpoint).

- `module/rds/variable.tf` — RDS-related variables and defaults (engine, engine_version, admin username/password, storage, DB class, backup retention, RDS_CIDR and `PUBLIC_ACCESSIBLE`).

- `webserver/webserver_instance.tf` — top-level glue and compute resources:
  - Calls modules: `module.levelup-vpc` and `module.levelup-rds` (sources `../module/vpc` and `../module/rds`).
  - Creates `aws_security_group` for webservers (SSH/HTTP/HTTPS), `aws_key_pair` (reads `var.PUBLIC_KEY_PATH`).
  - Launch configuration with `user_data` loaded from `webserver/user_data.sh` and an Auto Scaling Group across public subnets.
  - Application LB + target group + listener.
  - Outputs: `load_balancer_output` (ALB DNS name).

- `webserver/webserver_alb.tf` — security group for ALB allowing HTTP/HTTPS from 0.0.0.0/0.

- `webserver/variable.tf` — webserver variables such as `AMIS` map per region, `INSTANCE_TYPE`, `SSH_CIDR_WEB_SERVER`, `PUBLIC_KEY_PATH`, `ENVIRONMENT` and `AWS_REGION`.

- `webserver/user_data.sh` — simple bootstrap script that installs `nginx` and writes a minimal HTML page showing server IP. It computes the server IP from `ifconfig` and writes it into `/var/www/html/index.html`.

## Important defaults & quick safety notes ⚠️🔒

- Default AWS region: `us-east-2` (change via `AWS_REGION`).
- RDS defaults (in `module/rds/variable.tf`): `LEVELUP_RDS_USERNAME=adminuser`, `LEVELUP_RDS_PASSWORD=adminpassword`. For any real use, override these values with secure secrets (use `terraform.tfvars`, environment variables, or a secrets manager).
- `RDS_CIDR` default is `0.0.0.0/0` and `PUBLIC_ACCESSIBLE = true`. These are insecure for production — change to limit access (e.g., the webserver SG or a private bastion host) and set `PUBLIC_ACCESSIBLE = false` for production RDS.
- `PUBLIC_KEY_PATH` default: `~/.ssh/levelup_key.pub`. Ensure the public key exists or change the path (or create a keypair in AWS and reference it).

## How to deploy (quick start) ⛳

Prerequisites:
- Terraform installed (v1.x recommended).
- AWS CLI configured (or set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `AWS_PROFILE`).
- A public SSH key available at the path in `var.PUBLIC_KEY_PATH` or update the variable.


Recommended flow — run Terraform from the repository root (`/Terraform/Casestudy_#1`):

1) Make sure the root `main.tf` correctly references your modules and/or environment configuration. If `main.tf` is not set up, either:
  - Fix `main.tf` so it includes (or calls) the `webserver` configuration and modules under `module/`, or
  - Use the alternate approach shown below.

2) From the repository root run:

```bash
# run from repo root
cd /Terraform/Casestudy_#1

# initialize providers and modules
terraform init

# plan and save
terraform plan -out plan.tfplan

# apply the saved plan
terraform apply "plan.tfplan"
```

Alternate (no root changes): run Terraform commands while staying in root but targeting the `webserver/` directory using `-chdir`:

```bash
terraform -chdir=webserver init
terraform -chdir=webserver plan -out webserver/plan.tfplan
terraform -chdir=webserver apply "webserver/plan.tfplan"
```

After `apply` succeeds, check outputs:
- ALB DNS name (output `load_balancer_output`) — use this in a browser to see the web page.
- RDS endpoint (output `rds_prod_endpoint`) — connect from a client allowed by your `RDS_CIDR` or via EC2 instance depending on security settings.

## Useful variable overrides

Create a `terraform.tfvars` in `Casestudy_#1/` or pass `-var` flags. Example `terraform.tfvars`:

```hcl
ENVIRONMENT = "production"
AWS_REGION = "us-east-2"
PUBLIC_KEY_PATH = "~/.ssh/my_key.pub"
# RDS secrets should not be stored in plain text in a repo
LEVELUP_RDS_USERNAME = "myuser"
LEVELUP_RDS_PASSWORD = "supersecret"
RDS_CIDR = "10.0.0.0/16" # limit access to VPC or provide appropriate CIDR
PUBLIC_ACCESSIBLE = false
```

## Outputs to expect

- `load_balancer_output` — ALB DNS name (visit in browser).
- `rds_prod_endpoint` — RDS endpoint to connect to (hostname:port).

## Security & best-practices recommendations ✅

- DO NOT keep `LEVELUP_RDS_PASSWORD` in repo. Use environment variables, Terraform Cloud/Enterprise, or secrets manager integrations.
- Set `PUBLIC_ACCESSIBLE = false` for RDS and restrict `RDS_CIDR` to a narrow range (prefer private subnet access only).
- Restrict SSH (`SSH_CIDR_WEB_SERVER`) to your administrative IPs.
- Use an IAM role for Terraform execution (or short-lived credentials).
- Consider enabling multi-AZ RDS (`multi_az = true`) and backups for production-grade resilience.

## Troubleshooting tips 🩺

- If `terraform init` fails, check network and provider versions. Ensure you can reach provider endpoints.
- If instances fail to join the ALB, check security groups and the target group health-check settings.
- If RDS is not reachable, verify `db_subnet_group` subnets are private and SGs permit inbound MySQL from the webserver SG.
- Inspect Terraform logs with `TF_LOG=DEBUG terraform apply` (only for debugging).

## Next steps / enhancements ✨

- Move secrets to a secure store and integrate with Terraform (e.g., AWS Secrets Manager).
- Replace `aws_launch_configuration` with `aws_launch_template` and migrate to modern ASG patterns.
- Add CloudWatch alarms for ASG, RDS, and ALB metrics.
- Add automated tests (Terratest or similar) to validate resources in a CI pipeline.

---