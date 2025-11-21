# AWS CodeDeploy Demo

A comprehensive demonstration project showcasing AWS CodeDeploy for automated deployment of web applications to EC2 instances. This project includes a simple HTML website, deployment scripts, and GitHub Actions workflows for CI/CD pipeline automation.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Deployment](#deployment)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🔍 Overview

This project demonstrates how to:
- Set up AWS CodeDeploy for automated application deployments
- Deploy a simple web application to EC2 instances
- Use GitHub Actions for CI/CD automation
- Implement deployment lifecycle hooks
- Validate successful deployments

The demo deploys a simple HTML website to Apache web servers running on EC2 instances using AWS CodeDeploy service.

## 🏗️ Architecture

```
GitHub Repository → S3 Bucket → AWS CodeDeploy → EC2 Instance(s)
                                     ↓
                              Apache Web Server (/var/www/html)
```

**Components:**
- **Source**: GitHub repository containing the web application
- **Artifact Storage**: S3 bucket for storing deployment packages
- **Deployment Service**: AWS CodeDeploy for orchestrating deployments
- **Target**: EC2 instances running Apache HTTP Server
- **CI/CD**: GitHub Actions for automated deployment workflows

## ✅ Prerequisites

Before using this project, ensure you have:

### AWS Resources
- AWS Account with appropriate permissions
- EC2 instances with CodeDeploy agent installed
- S3 bucket for storing deployment artifacts
- CodeDeploy application and deployment group configured
- IAM roles for CodeDeploy service and EC2 instances

### Local Development
- AWS CLI configured with appropriate credentials
- Git installed
- Basic understanding of AWS CodeDeploy concepts

### GitHub Secrets
Configure the following secrets in your GitHub repository:
- `AWS_ACCESS_KEY_ID`: AWS access key with CodeDeploy permissions
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `S3_BUCKET_NAME`: S3 bucket name for storing deployment artifacts

## 📁 Project Structure

```
aws-codeploy-demo/
├── README.md                     # This file
├── index.html                    # Simple HTML website
├── appspec.yml                   # CodeDeploy application specification
├── scripts/                      # Deployment lifecycle scripts
│   ├── BeforeInstall.sh         # Pre-installation tasks
│   ├── AfterInstall.sh          # Post-installation tasks
│   ├── ApplicationStart.sh      # Application startup
│   └── ValidateService.sh       # Deployment validation
└── .github/workflows/           # GitHub Actions workflows
    ├── deploy.yml               # Basic deployment workflow (commented)
    ├── website_deploy.yml       # Active deployment workflow
    └── [other workflows...]     # Additional utility workflows
```

## 🚀 Setup Instructions

### 1. AWS Infrastructure Setup

#### Create CodeDeploy Application
```bash
aws deploy create-application \
  --application-name my-webapp \
  --compute-platform Server
```

#### Create Deployment Group
```bash
aws deploy create-deployment-group \
  --application-name my-webapp \
  --deployment-group-name production \
  --service-role-arn arn:aws:iam::ACCOUNT-ID:role/CodeDeployServiceRole \
  --ec2-tag-filters Key=Environment,Value=Production,Type=KEY_AND_VALUE
```

#### Prepare EC2 Instances
1. Launch EC2 instances with appropriate tags
2. Install and start the CodeDeploy agent:
```bash
# Amazon Linux 2
sudo yum update -y
sudo yum install -y ruby wget
cd /home/ec2-user
wget https://aws-codedeploy-region.s3.region.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
```

### 2. Repository Configuration

#### Clone Repository
```bash
git clone https://github.com/your-username/aws-codeploy-demo.git
cd aws-codeploy-demo
```

#### Configure GitHub Secrets
1. Go to your repository's Settings → Secrets and variables → Actions
2. Add the required secrets listed in [Prerequisites](#prerequisites)

## 🚀 Deployment

### Manual Deployment via AWS CLI

1. **Package the application:**
```bash
zip -r website.zip index.html scripts appspec.yml
```

2. **Upload to S3:**
```bash
aws s3 cp website.zip s3://your-bucket-name/website.zip
```

3. **Create deployment:**
```bash
aws deploy create-deployment \
  --application-name my-webapp \
  --deployment-group-name production \
  --s3-location bucket=your-bucket-name,key=website.zip,bundleType=zip \
  --file-exists-behavior OVERWRITE
```

### Automated Deployment via GitHub Actions

#### Using the Website Deploy Workflow

1. Navigate to **Actions** tab in your GitHub repository
2. Select **Deploy Website with CodeDeploy** workflow
3. Click **Run workflow**
4. Provide:
   - **Application Name**: Your CodeDeploy application name
   - **Deployment Group**: Your deployment group name
5. Click **Run workflow**

The workflow will:
- Package the application files
- Upload to S3 with timestamp
- Trigger CodeDeploy deployment
- Monitor deployment status

## 🔄 GitHub Actions Workflows

### website_deploy.yml
**Purpose**: Manual deployment workflow with custom parameters

**Trigger**: `workflow_dispatch` (manual trigger)

**Features**:
- Configurable application and deployment group names
- Automatic artifact packaging and S3 upload
- Timestamped deployments for versioning

**Usage**: Ideal for production deployments with specific targeting

### deploy.yml (Commented)
**Purpose**: Automatic deployment on code changes

**Trigger**: Push to main branch (currently disabled)

**Features**:
- Automatic deployment on git push
- GitHub integration for artifact sourcing

**Usage**: Uncomment and configure for continuous deployment

## 📝 Deployment Lifecycle Scripts

### BeforeInstall.sh
- Installs Apache HTTP Server if not present
- Stops Apache service before deployment
- Prepares the environment for new application version

### AfterInstall.sh
- Placeholder for post-installation tasks
- Set file permissions, move files, configure settings

### ApplicationStart.sh
- Starts the Apache HTTP Server
- Ensures the web service is running

### ValidateService.sh
- Performs health check on deployed application
- Validates that the service is responding correctly
- Fails deployment if validation fails

## 🐛 Troubleshooting

### Common Issues

#### Deployment Fails at BeforeInstall
- **Cause**: CodeDeploy agent not installed or not running
- **Solution**: Verify agent installation and status on EC2 instances

#### Permission Denied Errors
- **Cause**: Insufficient IAM permissions
- **Solution**: Verify CodeDeploy service role and EC2 instance profile permissions

#### Validation Failure
- **Cause**: Apache not responding or service not started
- **Solution**: Check Apache logs and ensure port 80 is accessible

#### S3 Upload Failures
- **Cause**: Invalid S3 bucket permissions or name
- **Solution**: Verify bucket exists and GitHub Actions have write permissions

### Debugging Commands

```bash
# Check CodeDeploy agent status
sudo service codedeploy-agent status

# View CodeDeploy agent logs
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log

# Check Apache status
sudo systemctl status httpd

# View Apache error logs
sudo tail -f /var/log/httpd/error_log

# Test local connectivity
curl -f http://localhost
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow AWS best practices for security and cost optimization
- Test deployments in a development environment first
- Document any new scripts or workflows
- Ensure all deployment scripts are idempotent

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Additional Resources

- [AWS CodeDeploy Documentation](https://docs.aws.amazon.com/codedeploy/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS CLI CodeDeploy Commands](https://docs.aws.amazon.com/cli/latest/reference/deploy/)
- [CodeDeploy Agent Installation](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install.html)

---

**Note**: This is a demonstration project. For production use, consider additional security measures, monitoring, and backup strategies.