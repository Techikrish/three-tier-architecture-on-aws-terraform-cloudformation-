## Project Overview

This project demonstrates the automated deployment of a **highly available, scalable, and secure three-tier web application architecture on Amazon Web Services (AWS)**. It showcases the power of Infrastructure as Code (IaC) by providing complete provisioning scripts using both **Terraform** and **AWS CloudFormation**.

For Terraform, the project utilizes **Amazon S3 for remote state management** and **Amazon DynamoDB for state locking**, ensuring collaborative development and preventing concurrent infrastructure modifications.

## Architecture

The deployed architecture consists of three logical tiers:

1. **Web Tier (Public):** An **Application Load Balancer (ALB)** distributes incoming web traffic across the application servers. This tier resides in public subnets, accessible from the internet.
2. **Application Tier (Private):** **EC2 instances** running a web server (Apache/PHP) are managed by an **Auto Scaling Group (ASG)**. These instances are placed in private subnets, ensuring they are not directly exposed to the internet. Outbound internet access for updates is facilitated by **NAT Gateways**.
3. **Database Tier (Private):** An **Amazon RDS for MySQL** instance provides a managed, highly available relational database. This tier is in its own private subnets, with strict network rules allowing access only from the application tier.

**Key components include:**

- **Networking (VPC):** Custom VPC with public, private application, and private database subnets across two Availability Zones.
- **Security:** Granular **Security Groups** control traffic flow between tiers.
- **Availability:** Multi-AZ deployment for all critical components (ALB, ASG instances, RDS).
- **Scalability:** Auto Scaling Group automatically adjusts the number of application instances based on demand.
- **Managed Services:** Leveraging AWS managed services like ALB, ASG, and RDS reduces operational overhead.

## How to Deploy

### 1. Deploy with Terraform

This project uses a modular Terraform approach.

**Prerequisites:**

- **AWS Account:** Configured with programmatic access (AWS CLI credentials).
- **Terraform:** [Install Terraform](https://developer.hashicorp.com/terraform/downloads) (version `~> 1.0`).
- **AWS CLI:** [Install AWS CLI](https://aws.amazon.com/cli/).
- **Git:** Basic Git knowledge.

**Steps:**

1. **Clone the repository:**Bash
    
    `git clone https://github.com/Techikrish/three-tier-architecture-on-aws-terraform-cloudformation-.git
    cd three-tier-architecture-on-aws-terraform-cloudformation/terraform`
    
2. **Initialize Terraform:**
Terraform will download the necessary providers and configure the S3 backend (ensure your S3 bucket and DynamoDB table for state locking exist and are correctly configured as per `backend.tf`) Replace with your S3 bucket name and Replace with your DynamoDB table name .Bash
    
    `terraform init`
    
3. **Review the plan:**
This command shows you what Terraform will create, modify, or destroy.Bash
    
    `terraform plan`
    
4. **Apply the configuration:**
This will provision all the AWS resources.Bash
    
    `terraform apply --auto-approve`
    
5. **Access the Application:**
Once `terraform apply` is complete, get the ALB DNS name from the Terraform output:Bash
    
    `terraform output alb_dns_name`
    
    Open the DNS name in your web browser. You should see a PHP info page.
    To verify database connectivity, append `/db-test.php` to the ALB DNS name (e.g., `http://<ALB_DNS_NAME>/db-test.php`).
    
6. **Clean up (Destroy Resources):**
To avoid incurring AWS costs, always remember to destroy the resources when you're done.Bash
    
    `terraform destroy --auto-approve`
    

---

### 2. Deploy with CloudFormation

This project uses CloudFormation templates for native AWS provisioning. You'll deploy these as separate stacks due to dependencies.

**Prerequisites:**

- **AWS Account:** Configured with programmatic access (AWS CLI credentials).
- **AWS CLI:** Ensure it's configured for the region you're deploying to.

**Steps:**

1. **Clone the repository:**Bash
    
    `git clone https://github.com/Techikrish/three-tier-architecture-on-aws-terraform-cloudformation-.git
    cd three-tier-architecture-on-aws-terraform-cloudformation/terraform`
    
2. **Deploy the Network Stack:**Bash
    
    `aws cloudformation create-stack \
      --stack-name ThreeTierNetworkStack \
      --template-body file://three-tier-architecture-network.yaml \
      --parameters ParameterKey=ProjectName,ParameterValue=three-tier-app \
                   ParameterKey=AvailabilityZone1,ParameterValue=us-east-1a \
                   ParameterKey=AvailabilityZone2,ParameterValue=us-east-1b \
      --capabilities CAPABILITY_IAM # Required if your template creates IAM roles`
    
    *(Adjust `AvailabilityZone1` and `AvailabilityZone2` to your desired region's AZs, e.g., `ap-south-1a`, `ap-south-1b`)*
    
3. **Deploy the Database Stack:**
Wait for the `ThreeTierNetworkStack` to complete (`CREATE_COMPLETE`). You'll need to provide database credentials.Bash
    
    `aws cloudformation create-stack \
      --stack-name ThreeTierDatabaseStack \
      --template-body file://three-tier-architecture-database.yaml \
      --parameters ParameterKey=ProjectName,ParameterValue=three-tier-app \
                   ParameterKey=DbUsername,ParameterValue=<YOUR_DB_USERNAME> \
                   ParameterKey=DbPassword,ParameterValue=<YOUR_DB_PASSWORD> \
                   ParameterKey=DbName,ParameterValue=webappdb \
                   ParameterKey=DbEngineVersion,ParameterValue=8.0 \
                   ParameterKey=DbInstanceClass,ParameterValue=db.t3.micro \
      --capabilities CAPABILITY_IAM`
    
4. **Deploy the Application Stack:**
Wait for the `ThreeTierDatabaseStack` to complete. You'll need the database endpoint from the database stack's outputs.Bash
    
    `# First, get the DB Endpoint from the Database stack outputs
    DB_ENDPOINT=$(aws cloudformation describe-stacks --stack-name ThreeTierDatabaseStack --query "Stacks[0].Outputs[?OutputKey=='DbEndpoint'].OutputValue" --output text)
    echo "DB Endpoint: $DB_ENDPOINT"
    
    aws cloudformation create-stack \
      --stack-name ThreeTierApplicationStack \
      --template-body file://three-tier-architecture-application.yaml \
      --parameters ParameterKey=ProjectName,ParameterValue=three-tier-app \
                   ParameterKey=AmiId,ParameterValue=<YOUR_REGION_AMI_ID> \
                   ParameterKey=InstanceType,ParameterValue=t2.micro \
                   ParameterKey=DbEndpoint,ParameterValue="$DB_ENDPOINT" \
                   ParameterKey=DbUsername,ParameterValue=<YOUR_DB_USERNAME> \
                   ParameterKey=DbPassword,ParameterValue=<YOUR_DB_PASSWORD> \
                   ParameterKey=DbName,ParameterValue=webappdb \
      --capabilities CAPABILITY_IAM`
    
    *(Replace `<YOUR_REGION_AMI_ID>` with an actual Amazon Linux 2 AMI ID for your chosen region, and fill in your DB credentials again.)*
    
5. **Access the Application:**
Once the `ThreeTierApplicationStack` is complete, find the ALB DNS Name in its outputs (either via console or CLI `describe-stacks`). Open the DNS name in your browser.
6. **Clean up (Delete Stacks):**
Delete stacks in reverse order of creation:Bash
    
    `aws cloudformation delete-stack --stack-name ThreeTierApplicationStack
    aws cloudformation wait stack-delete-complete --stack-name ThreeTierApplicationStack
    
    aws cloudformation delete-stack --stack-name ThreeTierDatabaseStack
    aws cloudformation wait stack-delete-complete --stack-name ThreeTierDatabaseStack
    
    aws cloudformation delete-stack --stack-name ThreeTierNetworkStack
    aws cloudformation wait stack-delete-complete --stack-name ThreeTierNetworkStack`