#!/bin/bash

# ==========================================================
# Open edX Platform Deployment Automation (Kubernetes)
# Author: DevOps Automation Script
# Purpose: Automated deployment for assessment submission
# ==========================================================

set -e

echo "=========================================================="
echo " Open edX Kubernetes Deployment | Automated CI Deployment "
echo "=========================================================="

# Configuration
NAMESPACE="openedx"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="deployment_${TIMESTAMP}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a $LOG_FILE
    exit 1
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a $LOG_FILE
}

# Prerequisite checks
check_prerequisites() {
    log "Validating system prerequisites..."

    command -v kubectl >/dev/null 2>&1 || error "kubectl is required but not installed."
    command -v helm >/dev/null 2>&1 || warn "helm not detected (optional)."
    command -v aws >/dev/null 2>&1 || warn "aws CLI not detected (optional for AWS automation)."

    kubectl cluster-info >/dev/null 2>&1 || error "Kubernetes cluster is not accessible."

    log "Prerequisite validation completed successfully."
}

# Namespace creation
create_namespace() {
    log "Ensuring namespace exists: $NAMESPACE"
    kubectl apply -f kubernetes/namespaces/openedx-namespace.yaml || error "Namespace creation failed."
}

# Storage provisioning
apply_storage() {
    log "Applying persistent storage resources..."
    kubectl apply -f kubernetes/storage/ || error "Storage configuration failed."
}

# ConfigMaps and configuration
apply_configs() {
    log "Applying application configuration (ConfigMaps)..."
    kubectl apply -f kubernetes/configmaps/ || error "ConfigMaps deployment failed."
}

# Deploy LMS and CMS workloads
deploy_apps() {
    log "Deploying Open edX application components..."

    # Deploy LMS
    log "Deploying LMS service..."
    kubectl apply -f kubernetes/deployments/lms-deployment.yaml || error "LMS deployment failed."
    kubectl apply -f kubernetes/services/lms-service.yaml || error "LMS service creation failed."

    # Deploy CMS
    log "Deploying CMS service..."
    kubectl apply -f kubernetes/deployments/cms-deployment.yaml || error "CMS deployment failed."
    kubectl apply -f kubernetes/services/cms-service.yaml || error "CMS service creation failed."
}

# Autoscaling setup
apply_autoscaling() {
    log "Applying Horizontal Pod Autoscaler (HPA) configurations..."
    kubectl apply -f kubernetes/hpa/ || error "HPA configuration failed."
}

# Ingress routing
apply_ingress() {
    log "Applying ingress routing rules..."
    kubectl apply -f kubernetes/ingress/ || error "Ingress configuration failed."
}

# Verification checks
verify_deployment() {
    log "Performing post-deployment validation..."

    log "Pod status check:"
    kubectl get pods -n $NAMESPACE

    log "Service status check:"
    kubectl get svc -n $NAMESPACE

    log "Ingress status check:"
    kubectl get ingress -n $NAMESPACE

    log "Autoscaling status check:"
    kubectl get hpa -n $NAMESPACE

    log "Validation completed."
}

# Health checks
health_check() {
    log "Executing basic platform health checks..."

    if kubectl get svc -n $NAMESPACE | grep -q "LoadBalancer"; then
        EXTERNAL_IP=$(kubectl get svc -n $NAMESPACE | grep LoadBalancer | awk '{print $4}')

        if [[ $EXTERNAL_IP != "<pending>" ]]; then
            log "Testing external endpoint availability: http://$EXTERNAL_IP"
            curl -I --max-time 10 http://$EXTERNAL_IP 2>/dev/null | head -1 || warn "External endpoint not responding yet."
        else
            warn "LoadBalancer external endpoint is still pending."
        fi
    else
        warn "No LoadBalancer service detected for external health check."
    fi

    log "Health check process completed."
}

# Main deployment pipeline
main() {
    log "Starting automated Open edX deployment pipeline..."

    check_prerequisites
    create_namespace
    apply_storage
    apply_configs
    deploy_apps
    apply_autoscaling
    apply_ingress

    log "Waiting for resources to initialize..."
    sleep 30

    verify_deployment
    health_check

    log "=========================================================="
    log "Deployment completed successfully."
    log "Deployment log file: $LOG_FILE"
    log "Namespace: $NAMESPACE"
    log "To monitor resources: kubectl get all -n $NAMESPACE"
    log "=========================================================="
}

# Help function
show_help() {
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  deploy     - Run full deployment pipeline (default)"
    echo "  verify     - Validate running deployment resources"
    echo "  clean      - Remove deployed resources from cluster"
    echo "  help       - Show available commands"
}

# Cleanup function
cleanup() {
    log "Initiating cleanup process for Open edX deployment..."

    kubectl delete -f kubernetes/ingress/ || true
    kubectl delete -f kubernetes/hpa/ || true
    kubectl delete -f kubernetes/services/ || true
    kubectl delete -f kubernetes/deployments/ || true
    kubectl delete -f kubernetes/configmaps/ || true
    kubectl delete -f kubernetes/storage/ || true
    kubectl delete namespace $NAMESPACE || true

    log "Cleanup process completed."
}

# Argument handling
case "${1:-deploy}" in
    deploy)
        main
        ;;
    verify)
        verify_deployment
        ;;
    clean|cleanup)
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac

