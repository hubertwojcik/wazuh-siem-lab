# Wazuh SIEM lab

This is a lab for testing Wazuh SIEM to prepare for role DevSecOps

## Stack

- **Wazuh** – SIEM/XDR (manager + agents)
- **Terraform** – provisioning AWS infrastructure
- **Ansible** – configuration and hardening of machines
- **GitHub Actions** – CI/CD pipeline

## Goal

The goal of this lab is create fully working infrastructure on AWS cloud

## Security Practices

This repository follows DevSecOps best practices:

- **Protected main branch** – direct pushes disabled, all changes require a Pull Request
- **Force push blocked** – branch history is immutable
- **Status checks required** – CI pipeline must pass before merge
- **Secret scanning enabled** – GitHub automatically detects leaked credentials
- **Dependabot alerts enabled** – automatic vulnerability notifications
- **No secrets in code** – AWS credentials stored as GitHub Secrets, `.gitignore` excludes all sensitive files
- **PR template** – every pull request follows a structured review checklist
- **Automatic branch deletion** – merged branches are cleaned up automatically
