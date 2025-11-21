# AWS CodeDeploy Demo

A comprehensive demonstration project showcasing AWS CodeDeploy integration with GitHub Actions for automated deployment of a web application to EC2 instances running Apache HTTP Server.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Deployment Process](#deployment-process)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Configuration Files](#configuration-files)
- [Deployment Scripts](#deployment-scripts)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

This project demonstrates how to implement a complete CI/CD pipeline using AWS CodeDeploy and GitHub Actions to deploy a simple HTML website to EC2 instances. It includes:

- **Automated deployment pipeline** triggered by GitHub Actions
- **Blue/green deployment strategies** using AWS CodeDeploy
- **Infrastructure as Code** practices with proper configuration management
- **Health checks and validation** to ensure successful deployments
- **Multiple workflow examples** for various AWS operations

## 🏗️ Architecture

```
GitHub Repository
       ↓
GitHub Actions Workflow
       ↓
AWS S3 (Artifact Storage)
       ↓
AWS CodeDeploy
       ↓
EC2 Instance(s) with Apache
```

### Key Components:

1. **GitHub Actions**: Orchestrates the CI/CD pipeline
2. **AWS S3**: Stores deployment artifacts
3. **AWS CodeDeploy**: Manages the deployment process
4. **EC2 Instances**: Target servers running Apache HTTP Server
5. **Application Load Balancer** (optional): Distributes traffic across instances

## 🛠️ Prerequisites

### AWS Resources Required:

- **EC2 Instance(s)** with CodeDeploy agent installed
- **IAM Service Role** for CodeDeploy with appropriate permissions
- **IAM Instance Profile** for EC2 instances
- **S3 Bucket** for storing deployment artifacts
- **CodeDeploy Application** and Deployment Group
- **Security Groups** configured for web traffic

### GitHub Secrets Required:

```bash
AWS_ACCESS_KEY_ID          # AWS access key with CodeDeploy permissions
AWS_SECRET_ACCESS_KEY      # AWS secret access key
S3_BUCKET_NAME            # S3 bucket name for artifacts
```

### Local Development:

- AWS CLI configured
- Git installed
- Basic understanding of AWS services

## 📁 Project Structure

```
aws-codeploy-demo/
├── .github/
│   └── workflows/
│       ├── deploy.yml              # Main deployment workflow (commented)
│       ├── website_deploy.yml      # Active deployment workflow
│       └── [various other workflows for AWS operations]
├── scripts/
│   ├── BeforeInstall.sh           # Pre-installation setup
│   ├── AfterInstall.sh            # Post-installation configuration
│   ├── ApplicationStart.sh        # Start the application
│   └── ValidateService.sh         # Health check validation
├── appspec.yml                    # CodeDeploy specification
├── index.html                     # Sample web application
└── README.md                      # This file
```

## 🚀 Setup Instructions

### 1. AWS Infrastructure Setup

#### Create IAM Roles:

**CodeDeploy Service Role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**EC2 Instance Profile:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-deployment-bucket",
        "arn:aws:s3:::your-deployment-bucket/*"
      ]
    }
  ]
}
```

#### Launch EC2 Instances:

1. Launch EC2 instance(s) with Amazon Linux 2
2. Attach the IAM instance profile
3. Install CodeDeploy agent:

```bash
sudo yum update -y
sudo yum install -y ruby wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
```

#### Create CodeDeploy Application:

```bash
aws deploy create-application \
    --application-name your-app-name \
    --compute-platform Server
```

#### Create Deployment Group:

```bash
aws deploy create-deployment-group \
    --application-name your-app-name \
    --deployment-group-name your-deployment-group \
    --service-role-arn arn:aws:iam::account:role/CodeDeployServiceRole \
    --ec2-tag-filters Key=Environment,Value=Production,Type=KEY_AND_VALUE
```

### 2. GitHub Repository Setup

1. Fork or clone this repository
2. Set up the required GitHub secrets in repository settings
3. Modify the workflow files with your specific AWS resource names
4. Push changes to trigger the deployment pipeline

## 🔄 Deployment Process

### Manual Deployment (via GitHub Actions):

1. Navigate to the **Actions** tab in your GitHub repository
2. Select the **"Deploy Website with CodeDeploy"** workflow
3. Click **"Run workflow"**
4. Provide the required inputs:
   - **Application Name**: Your CodeDeploy application name
   - **Deployment Group**: Your deployment group name
5. Monitor the deployment progress in the Actions tab

### Automatic Deployment:

Uncomment the trigger section in `deploy.yml` to enable automatic deployments on pushes to the main branch:

```yaml
on:
  push:
    branches: [ main ]
```

## ⚙️ GitHub Actions Workflows

### Primary Deployment Workflow (`website_deploy.yml`)

This workflow performs the following steps:

1. **Checkout**: Downloads the source code
2. **Configure AWS**: Sets up AWS credentials and region
3. **Package**: Creates a ZIP archive of the application
4. **Upload**: Stores the artifact in S3
5. **Deploy**: Triggers CodeDeploy deployment

### Additional Workflows

The repository includes numerous utility workflows for AWS operations:

- **EKS Management**: Cluster creation, deletion, pod restarts
- **RDS Operations**: Instance management and reboots
- **Certificate Management**: ACM certificate lifecycle
- **Queue Management**: SQS operations
- **Auto Scaling**: EC2 Auto Scaling Group operations
- **Multi-Cloud Support**: Azure and GCP instance management

## 📄 Configuration Files

### `appspec.yml`

Defines the deployment specification:

```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /var/www/html
    overwrite: true
hooks:
  BeforeInstall:
    - location: scripts/BeforeInstall.sh
      timeout: 300
      runas: root
  # ... additional hooks
```

**Key Sections:**
- **files**: Specifies source and destination paths
- **hooks**: Defines lifecycle event scripts
- **permissions**: Sets file and directory permissions (if needed)

### Lifecycle Hooks

1. **BeforeInstall**: Prepare the instance (install Apache, stop services)
2. **AfterInstall**: Configure the application post-installation
3. **ApplicationStart**: Start required services (Apache HTTP Server)
4. **ValidateService**: Perform health checks to ensure deployment success

## 📜 Deployment Scripts

### `BeforeInstall.sh`
- Installs Apache HTTP Server if not present
- Stops existing Apache processes
- Prepares the environment for new deployment

### `AfterInstall.sh`
- Placeholder for post-installation configuration
- File permission adjustments
- Configuration file updates

### `ApplicationStart.sh`
- Starts the Apache HTTP Server
- Enables the service for automatic startup

### `ValidateService.sh`
- Performs health check via HTTP request to localhost
- Validates that the application is responding correctly
- Fails the deployment if validation fails

## 🔧 Troubleshooting

### Common Issues:

#### 1. CodeDeploy Agent Not Running
```bash
sudo service codedeploy-agent status
sudo service codedeploy-agent start
```

#### 2. Permission Issues
- Verify IAM roles and policies
- Check EC2 instance profile attachment
- Ensure S3 bucket permissions are correct

#### 3. Deployment Failures
```bash
# Check CodeDeploy agent logs
sudo cat /var/log/aws/codedeploy-agent/codedeploy-agent.log

# Check deployment logs
sudo cat /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log
```

#### 4. Apache Configuration Issues
```bash
sudo systemctl status httpd
sudo journalctl -u httpd
```

### Debugging Commands:

```bash
# Check deployment history
aws deploy list-deployments --application-name your-app-name

# Get deployment details
aws deploy get-deployment --deployment-id d-XXXXXXXXX

# Monitor deployment
aws deploy get-deployment --deployment-id d-XXXXXXXXX --query 'deploymentInfo.status'
```

## 🔒 Security Considerations

### Best Practices:

1. **IAM Principle of Least Privilege**
   - Grant minimal required permissions
   - Use specific resource ARNs when possible
   - Regularly audit and rotate credentials

2. **Secure Secret Management**
   - Use GitHub Secrets for sensitive data
   - Avoid hardcoding credentials in code
   - Consider using AWS Systems Manager Parameter Store

3. **Network Security**
   - Configure Security Groups with minimal required ports
   - Use private subnets for application servers when possible
   - Implement proper load balancer security groups

4. **Instance Security**
   - Keep EC2 instances updated
   - Use Systems Manager Session Manager instead of SSH when possible
   - Enable CloudTrail logging for audit trails

### Security Checklist:

- [ ] IAM roles follow least privilege principle
- [ ] Security Groups restrict unnecessary access
- [ ] SSL/TLS certificates are properly configured
- [ ] Secrets are stored in GitHub Secrets, not in code
- [ ] CloudTrail logging is enabled
- [ ] EC2 instances are in private subnets (if applicable)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes and commit: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Submit a pull request

### Development Guidelines:

- Follow AWS security best practices
- Test deployments in a development environment first
- Update documentation for any configuration changes
- Ensure all scripts are idempotent
- Add appropriate error handling to scripts

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions and support:

- **Documentation**: AWS CodeDeploy User Guide
- **Issues**: Use the GitHub Issues tab
- **AWS Support**: Contact AWS Support for service-specific issues

---

**Note**: This is a demonstration project. For production use, implement additional security measures, monitoring, and error handling as appropriate for your environment.