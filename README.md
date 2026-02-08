
OpenEdX Kubernetes Deployment

Author: Haram Fatima
Project Type: OpenEdX Deployment on Kubernetes
Deployment Tool: Tutor (Kubernetes mode)

Overview

This repository contains a production-oriented deployment setup for OpenEdX LMS/CMS on a Kubernetes environment.
It includes deployment configuration, architecture diagram, monitoring/logging support structure, rollback strategy, and automation scripts for easier deployment management.


Key Features

OpenEdX deployment on Kubernetes using Tutor
Modular folder structure for manifests, scripts, monitoring, and recovery
Architecture diagram included for infrastructure overview
Logging evidence included through deployment logs
Rollback and recovery structure for disaster recovery readiness
Monitoring support structure (CloudWatch integration readiness)
Production-ready design approach with scalability planning


Repository Structure

kubernetes/ → Kubernetes configuration and manifests
scripts/ → Deployment automation scripts
rollback/ → Rollback and recovery related files
recover-file/ → Recovery and backup support files
CloudWatch/ → Monitoring integration support



Quick Start

To start deployment using the provided automation script:

bash scripts/start.sh

To verify running workloads and check pods:

kubectl get pods -A openedx


Documentation

This repository includes a full technical assessment document explaining architecture, design decisions, monitoring, security readiness, backup strategy, and deployment deliverables.


Conclusion

This project demonstrates a structured and professional OpenEdX deployment approach on Kubernetes with production-level planning, automation, and troubleshooting evidence.
