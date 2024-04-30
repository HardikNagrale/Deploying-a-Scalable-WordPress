Scalable WordPress Site Deployment on AWS using Terraform
This project serves as a guide for deploying a scalable WordPress site on AWS using Terraform. It establishes an architecture where WordPress runs on EC2 instances, managed by an Elastic Load Balancer (ELB), and a MySQL database is hosted on Amazon RDS. Additionally, it integrates with AWS Route 53 for DNS management and AWS Certificate Manager (ACM) for SSL/TLS certificate provisioning.

Architecture Overview
The architecture comprises several key components:

VPC Setup: The Virtual Private Cloud (VPC) is configured with public and private subnets across multiple Availability Zones (AZs) for fault tolerance.
Database: Amazon RDS is utilized to deploy a MySQL database in a private subnet, ensuring data security.
Web Servers: EC2 instances, running WordPress, are deployed in public subnets behind an Elastic Load Balancer (ELB) to distribute incoming traffic.
Elastic Load Balancer (ELB): The ELB evenly distributes traffic among EC2 instances to ensure high availability and scalability.
Auto Scaling Group: This automatically adjusts the number of EC2 instances based on load, ensuring optimal performance.
Security Groups: Security rules are defined to control access to EC2 instances and the RDS database, ensuring network security.
DNS Configuration: Route 53 is used to manage the domain and route traffic to the ELB.
SSL/TLS Setup: ACM provisions SSL/TLS certificates and associates them with the ELB to enable secure connections.
How to Deploy
Prerequisites
Install Terraform: Follow the official Terraform installation guide here.
Linux/macOS:
Download the appropriate package for your operating system from the Terraform website.
Unzip the downloaded package.
Move the executable file to a directory included in your system's PATH.
Windows:
Download the appropriate package for your operating system from the Terraform website.
Extract the downloaded zip file.
Move the executable file (terraform.exe) to a directory included in your system's PATH.
Configure AWS Credentials: Ensure AWS access keys are configured either through environment variables or the AWS credentials file (~/.aws/credentials).
Terraform AWS Configuration
AWS IAM User: Create an IAM user with programmatic access and assign the necessary permissions (e.g., AmazonEC2FullAccess, AmazonRDSFullAccess, AmazonRoute53FullAccess, IAMFullAccess).
Access Key and Secret Key: Obtain the access key ID and secret access key for the IAM user.
Connect Terraform to AWS
Environment Variables:
Set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables with the IAM user's access key ID and secret access key, respectively.
bash

export AWS_ACCESS_KEY_ID=<your_access_key_id>
export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
Terraform Configuration File:
Alternatively, you can configure Terraform to use AWS credentials from the shared credentials file (~/.aws/credentials).
Open the ~/.aws/credentials file and add the IAM user's access key ID and secret access key under a profile name (e.g., [terraform]).
makefile

[terraform]
aws_access_key_id=<your_access_key_id>
aws_secret_access_key=<your_secret_access_key>
Set the AWS_PROFILE environment variable to specify the profile name (optional).
bash

export AWS_PROFILE=terraform
Deployment Steps
Clone this repository:
bash

git clone https://github.com/HardikNagrale/Deploying-a-Scalable-WordPress.git
Navigate to the project directory:

bash

cd Deploying-a-Scalable-WordPress


Initialize Terraform:
bash

terraform init
Review and modify variables: Open the variables.tf file and adjust variables according to your requirements.
Plan the deployment:
bash

terraform plan
Deploy the infrastructure:
bash

terraform apply
Confirm the deployment: Follow the on-screen instructions to confirm the deployment.
Making Changes
To make changes to the infrastructure:

Update the variables: Open the variables.tf file and modify variables as needed.
Re-run the deployment steps:
bash

terraform plan
terraform apply
Confirm the changes: Follow the on-screen instructions to confirm the changes.
Clean Up
To destroy the infrastructure and release AWS resources:

Run the following command:
bash

terraform destroy
Confirm the destruction: Follow the on-screen instructions to confirm the destruction.
