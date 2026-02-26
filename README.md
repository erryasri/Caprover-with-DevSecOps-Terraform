# Caprover with DevSecOps & Terraform

Deploy [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) on a self-hosted **CapRover** PaaS running on AWS EC2 — fully automated with **Terraform** infrastructure-as-code and a **GitHub Actions** DevSecOps CI/CD pipeline.

---

## Architecture Overview

![Architecture Overview](architechture%20overview.png)

## Tech Stack

| Layer              | Technology                                           |
| ------------------ | -------------------------------------------------    |
| Application        | OWASP Juice Shop (Node.js 22 / TypeScript / Angular) |
| Containerization   | Docker (multi-stage build)                           |
| Container Registry | GitHub Container Registry (GHCR)                     |
| PaaS / Deployment  | CapRover                                             |
| Infrastructure     | Terraform (AWS EC2, VPC, S3, IAM)                    |
| CI/CD              | GitHub Actions                                       |
| Auth               | GitHub OIDC → AWS IAM (keyless)                      |



## Infrastructure (Terraform)

### Bootstrap (`terraform/bootstrap/`)

One-time resources that enable the rest of the pipeline:

- **S3 State Bucket** — Encrypted remote state storage with versioning
- **GitHub OIDC Provider** — Keyless authentication from GitHub Actions to AWS
- **IAM Roles** — Scoped roles for GitHub Actions and Terraform operations

### Infra (`terraform/infra/`)

Runtime infrastructure:

- **VPC** with public subnet, internet gateway, and route table
- **EC2 Instance** — Ubuntu with Docker + CapRover installed via `user_data`
- **Security Group** — Inbound: SSH (22), HTTP (80), HTTPS (443), CapRover (3000)

## CI/CD Pipeline

### Branching Strategy

```
dev ──────► staging ──────► main (production)
```

### Application Pipelines

| Stage       | Trigger              | Steps                                              |
| ----------- | -------------------- | -------------------------------------------------- |
| Development | Push to `dev`        | ESLint → Docker Build → Trivy Scan → Push to GHCR  |
| Staging     | Push/PR to `staging` | SonarQube SAST / Code Quality Scan                 |
| Production  | Push/PR to `main`    | Deploy image to CapRover                           |
| DAST Scan   | Weekly (Saturday)    | OWASP ZAP baseline scan against live instance      |

### Terraform Pipelines

| Stage       | Trigger                           | Steps                                          |
| ----------- | --------------------------------- | ---------------------------------------------- |
| Dev         | Push to `dev` (terraform paths)   | Checkov IaC Scan → Terraform Plan (no apply)   |
| Production  | PR merged to `main` (terraform paths) | Terraform Plan → Apply + PR comment        |

## DevSecOps Security Tools

| Tool         | Type    | Stage       | Purpose                              |
| ------------ | ------- | ----------- | ------------------------------------ |
| **ESLint**   | Lint    | Development | Code style and error detection       |
| **Trivy**    | SCA     | Development | Container image vulnerability scan   |
| **Checkov**  | IaC     | Development | Terraform misconfiguration detection |
| **SonarQube**| SAST    | Staging     | Static code analysis & quality gate  |
| **OWASP ZAP**| DAST    | Scheduled   | Dynamic runtime security scanning    |
| **CycloneDX**| SBOM    | Build       | Software Bill of Materials generation|

## Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.13
- [Docker](https://docs.docker.com/get-docker/)
- AWS account with appropriate permissions
- GitHub repository with OIDC configured for AWS

### 1. Bootstrap Infrastructure

local bootstrap terraform run command:

```bash
cd terraform/bootstrap
terraform init
terraform plan
terraform apply
```

### 2. Deploy Infrastructure

local infrastructure terraform run command:

```bash
cd terraform/infra
terraform init
terraform plan
terraform apply
```

### 3. Configure CapRover

After EC2 is provisioned, access CapRover at `http://<EC2_PUBLIC_IP>:3000` to complete initial setup.

### 4. Set GitHub Secrets

Configure the following secrets in your GitHub repository:

| Secret              | Description                            |
| ------------------- | -------------------------------------- |
| `AWS_ROLE_ARN`      | IAM Role ARN for OIDC authentication   |
| `ZAP_TARGET_URL`    | Production URL for OWASP ZAP scanning  |
| `CAPROVER_PASSWORD` | CapRover admin password for deployment |
| `SONAR_TOKEN`       | SonarQube authentication token         |
| `SONAR_HOST_URL`    | SonarQube server URL                   |

### 5. Push Code

Push to the `dev` branch to trigger the CI/CD pipeline:

```bash
git checkout dev
git push origin dev
```

## License

This project uses [OWASP Juice Shop](https://github.com/juice-shop/juice-shop) which is licensed under the MIT License.
