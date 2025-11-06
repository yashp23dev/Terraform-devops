
# 🚀 ELK Stack Deployment on AWS with Terraform

This project automates the deployment of an **ELK Stack (Elasticsearch, Logstash, and Kibana)** on AWS using **Terraform** and shell provisioning.
It demonstrates how to create and configure an EC2 instance, install and run ELK components, and expose the Kibana dashboard for log analytics.

---

## 🧠 Overview

The **ELK Stack** is a powerful open-source solution for real-time log aggregation, visualization, and monitoring:

* **Elasticsearch** → Search and analytics engine
* **Logstash** → Log processing and transformation pipeline
* **Kibana** → Visualization and dashboard tool

This Terraform setup provisions infrastructure on AWS and automatically installs and configures the ELK components via the included Bash script.

---

## 🏗️ Architecture

```
          ┌──────────────────────────┐
          │        AWS Cloud         │
          │                          │
          │  +--------------------+  │
          │  |  EC2 Instance      |  │
          │  |--------------------|  │
          │  | Elasticsearch      |  │
          │  | Logstash           |  │
          │  | Kibana             |  │
          │  +--------------------+  │
          │                          │
          └──────────────────────────┘
```

---

## 📁 Project Structure

```
Demo-2/
├── createinstance.tf      # Terraform code to provision EC2 instance
├── varaible.tf            # Input variables for AWS region, AMI, etc.
├── installELK.sh          # Script to install Elasticsearch, Logstash, and Kibana
├── elasticsearch.yml      # Elasticsearch configuration file
├── kibana.yml             # Kibana configuration file
├── apache-01.conf         # Apache log input configuration for Logstash
└── README.md              # Project documentation
```

---

## ⚙️ Prerequisites

Before deploying, make sure you have:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
* [AWS CLI](https://aws.amazon.com/cli/) configured with access credentials
* An active AWS account
* Proper IAM permissions for creating EC2 instances, security groups, and key pairs

---

## 🚀 Deployment Steps

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yashp23dev/ELK-Terraform-AWS.git
cd Demo-2
```

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Validate the Configuration

```bash
terraform validate
```

### 4️⃣ Preview the Changes

```bash
terraform plan
```

### 5️⃣ Apply the Configuration

```bash
terraform apply -auto-approve
```

Terraform will:

* Create an EC2 instance
* Execute the `installELK.sh` script on the instance
* Install and configure Elasticsearch, Logstash, and Kibana

---

## 🌐 Accessing Kibana Dashboard

Once the deployment is complete:

1. Go to your **AWS EC2 console** → copy the **Public IP** of your instance.
2. Open your browser and navigate to:

   ```
   http://<instance-public-ip>:5601
   ```
3. The **Kibana dashboard** should be up and running 🎉

---

## 🧹 Cleanup

To remove all resources and avoid AWS costs:

```bash
terraform destroy -auto-approve
```

---

## 📄 Files Explanation

| File Name             | Description                                                     |
| --------------------- | --------------------------------------------------------------- |
| **createinstance.tf** | Creates the EC2 instance and configures security groups.        |
| **varaible.tf**       | Declares input variables like region, instance type, AMI ID.    |
| **installELK.sh**     | Installs and configures Elasticsearch, Logstash, Kibana on EC2. |
| **elasticsearch.yml** | Config file for Elasticsearch node setup.                       |
| **kibana.yml**        | Configuration for Kibana dashboard access.                      |
| **apache-01.conf**    | Logstash input pipeline configuration for Apache logs.          |

---

## 🧰 Technologies Used

* **Terraform** – Infrastructure as Code
* **AWS EC2** – Compute service for ELK hosting
* **Bash Scripting** – Automation of ELK installation
* **ELK Stack** – Log management and visualization

---

## 🏁 License

This project is licensed under the **MIT License**.
You’re free to use and modify it for learning or deployment purposes.

---
