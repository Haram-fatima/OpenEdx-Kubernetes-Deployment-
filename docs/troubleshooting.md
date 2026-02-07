# OpenEdX on Kubernetes Troubleshooting Guide
# Basic status checks
kubectl get all -n openedx
kubectl get events -n openedx --sort-by='.lastTimestamp'
kubectl logs -n openedx <pod-name> --tail=50
kubectl describe pod -n openedx <pod-name>

# Diagnose
kubectl describe pod <pod> -n openedx | grep -A 10 "Events:"
kubectl get pvc -n openedx

# Fixes
# • Check resource quotas: kubectl describe quota -n openedx
# • Verify PVC binding: kubectl get pv,pvc -n openedx
# • Adjust resource requests in deployment YAML

# Diagnose
kubectl exec -n openedx <pod> -- nc -zv <db-host> <port>
kubectl get configmaps -n openedx

# Fixes
# • Update DB credentials in Secrets: kubectl edit secret -n openedx
# • Verify network policies: kubectl get networkpolicy -n openedx
# • Test connectivity from pod: kubectl exec -it <pod> -- /bin/sh


# Diagnose
kubectl logs -n openedx -l app=nginx-ingress
kubectl get ingress -n openedx -o yaml
curl -I https://your-domain.com

# Fixes
# • Verify TLS secret: kubectl get secret openedx-tls-secret -n openedx
# • Check Ingress annotations for SSL redirect
# • Confirm LoadBalancer has external IP


# Diagnose
kubectl get hpa -n openedx -w
kubectl top pods -n openedx
kubectl describe hpa <name> -n openedx

# Fixes
# • Install metrics-server if missing
# • Set proper resource requests/limits in deployment
# • Adjust HPA thresholds: cpu: 70%, memory: 80%


# Diagnose
curl -I https://your-domain.com/static/file.css | grep cache-control
aws cloudfront get-distribution --id <distribution-id>

# Fixes
# • Verify CloudFront origin settings
# • Check Nginx cache headers configuration
# • Confirm WAF rules are attached to distribution

# Internal connectivity
kubectl run test-$(date +%s) --rm -i --image=alpine -- sh -c "
  apk add curl bind-tools >/dev/null 2>&1
  echo 'Testing service connectivity...'
  curl -s http://lms.openedx.svc.cluster.local:8000/health
  echo 'Testing DNS...'
  nslookup lms.openedx.svc.cluster.local
  echo 'Testing external...'
  curl -s https://google.com --connect-timeout 5
"


# Restart components
kubectl rollout restart deployment -n openedx

# Scale for immediate relief
kubectl scale deployment -n openedx lms --replicas=3

# Check configurations
kubectl apply -f kubernetes/ --dry-run=client -n openedx

# Rollback if needed
kubectl rollout undo deployment/<name> -n openedx

# Filter logs
kubectl logs -n openedx -l component=lms --tail=100 | grep -i error
kubectl logs -n openedx <pod> --previous  # Previous crashed instance

# Real-time monitoring
kubectl logs -n openedx -f -l component=lms
watch kubectl get pods -n openedx


