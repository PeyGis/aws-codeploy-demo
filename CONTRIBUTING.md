# Contributing to AWS CodeDeploy Demo

Thank you for your interest in contributing to this AWS CodeDeploy demonstration project! This guide will help you get started with contributing to this repository.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Testing Your Changes](#testing-your-changes)
- [Submitting Changes](#submitting-changes)
- [Code Style Guidelines](#code-style-guidelines)
- [Project Structure](#project-structure)
- [Getting Help](#getting-help)

## Getting Started

This project demonstrates AWS CodeDeploy functionality for deploying a simple web application. Before contributing, make sure you have:

- An AWS account with appropriate permissions for CodeDeploy
- Basic understanding of AWS CodeDeploy concepts
- Familiarity with Linux/Unix shell scripting
- Git installed on your local machine

### Prerequisites

- AWS CLI configured with appropriate credentials
- Basic knowledge of HTML/CSS (for web content changes)
- Understanding of Apache HTTP Server configuration
- Familiarity with systemctl commands

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:

1. Check the existing issues to avoid duplicates
2. Create a new issue with a clear title and description
3. Include steps to reproduce the problem (if applicable)
4. Provide information about your environment (OS, AWS region, etc.)

### Suggesting Enhancements

We welcome suggestions for improvements! Please:

1. Open an issue describing the enhancement
2. Explain the use case and benefits
3. Discuss the implementation approach if you have ideas

## Development Guidelines

### Project Structure

```
├── README.md              # Project documentation
├── CONTRIBUTING.md        # This file
├── appspec.yml           # CodeDeploy application specification
├── index.html            # Sample web application
└── scripts/              # CodeDeploy lifecycle scripts
    ├── BeforeInstall.sh  # Pre-installation setup
    ├── AfterInstall.sh   # Post-installation configuration
    ├── ApplicationStart.sh # Start the application
    └── ValidateService.sh  # Validate deployment success
```

### Making Changes

1. **Fork the repository** and create a new branch from `main`
2. **Make your changes** following the guidelines below
3. **Test your changes** thoroughly
4. **Submit a pull request** with a clear description

### Branch Naming Convention

Use descriptive branch names:
- `feature/add-new-script` - for new features
- `fix/deployment-issue` - for bug fixes
- `docs/update-readme` - for documentation updates
- `refactor/script-cleanup` - for code refactoring

## Testing Your Changes

### Local Testing

Before submitting changes, test them locally:

1. **Script Testing**: Ensure all shell scripts are executable and run without errors
   ```bash
   chmod +x scripts/*.sh
   bash -n scripts/*.sh  # Syntax check
   ```

2. **HTML Validation**: Validate HTML content
   ```bash
   # Test that index.html is valid HTML
   ```

3. **AppSpec Validation**: Validate the CodeDeploy specification
   ```bash
   # Ensure appspec.yml follows proper YAML syntax
   ```

### AWS Testing

If possible, test your changes with actual CodeDeploy:

1. Deploy to a test EC2 instance
2. Verify all lifecycle hooks execute successfully
3. Confirm the web application serves correctly
4. Test the validation script

## Submitting Changes

### Pull Request Process

1. **Update documentation** if your changes affect project setup or usage
2. **Write clear commit messages** following conventional commit format:
   - `feat: add new deployment script for database setup`
   - `fix: resolve permission issue in ApplicationStart script`
   - `docs: update README with troubleshooting section`

3. **Fill out the pull request template** completely
4. **Link related issues** in your PR description
5. **Request review** from maintainers

### Pull Request Checklist

Before submitting your PR, ensure:

- [ ] All scripts have proper execute permissions
- [ ] Shell scripts follow best practices (error handling, proper quoting)
- [ ] Changes are tested in a CodeDeploy environment (if possible)
- [ ] Documentation is updated to reflect changes
- [ ] Commit messages are clear and descriptive
- [ ] No sensitive information (credentials, personal data) is included

## Code Style Guidelines

### Shell Scripts

- Use `#!/bin/bash` shebang for all shell scripts
- Include error handling with `set -e` when appropriate
- Use meaningful variable names
- Add comments for complex operations
- Quote variables to prevent word splitting
- Use `sudo` only when necessary and document why

Example:
```bash
#!/bin/bash
set -e

echo "=== Starting Application Setup ==="

# Install required packages
if ! command -v httpd &> /dev/null; then
    sudo yum install -y httpd
fi

# Start the web server
sudo systemctl start httpd
sudo systemctl enable httpd

echo "Application setup completed successfully"
```

### HTML/CSS

- Use semantic HTML5 elements
- Maintain consistent indentation (2 spaces)
- Include proper meta tags
- Ensure responsive design principles

### YAML (appspec.yml)

- Use consistent indentation (2 spaces)
- Include comments for complex configurations
- Validate syntax before committing

## Getting Help

If you need help or have questions:

1. **Check existing issues** and pull requests
2. **Review AWS CodeDeploy documentation**
3. **Open a discussion** for general questions
4. **Create an issue** for specific problems

### Resources

- [AWS CodeDeploy User Guide](https://docs.aws.amazon.com/codedeploy/latest/userguide/)
- [AppSpec File Reference](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html)
- [CodeDeploy Best Practices](https://aws.amazon.com/blogs/devops/view-aws-codedeploy-logs-in-amazon-cloudwatch-console/)

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct:

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

Thank you for contributing to this AWS CodeDeploy demonstration project!