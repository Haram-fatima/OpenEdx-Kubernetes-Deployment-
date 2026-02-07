# Cost Optimization Analysis for OpenEdX on AWS

## Infrastructure Cost Breakdown (Monthly)

### Compute & Orchestration
- **AWS EKS Control Plane**: $75
- **EC2 Worker Nodes (3 x t3.large)**: $225 (Spot: ~$75)
- **Total Compute**: $300

### Managed Databases
- **RDS MySQL (db.t3.medium)**: $120
- **MongoDB Atlas (M10 Cluster)**: $80
- **Amazon Elasticsearch (t3.small)**: $90
- **Amazon ElastiCache Redis (cache.t3.micro)**: $60
- **Total Databases**: $350

### Networking & CDN
- **AWS CloudFront CDN**: $50 (pay-per-use)
- **Application Load Balancer**: $25
- **Data Transfer**: $20
- **Total Networking**: $95

### **Total Estimated Monthly Cost: $745**

## Optimization Strategies Implemented

### 1. **Spot Instance Utilization**
- Worker nodes deployed as Spot Instances (60-70% savings)
- Fallback to On-Demand for critical pods

### 2. **Right-Sizing Resources**
- Pod requests/limits optimized based on monitoring
- HPA thresholds set at 70% CPU / 80% Memory
- Resource Quotas prevent overspending

### 3. **Auto-Scaling Strategy**
- Horizontal Pod Autoscaling (2-10 replicas)
- Cluster Autoscaler for node optimization
- Scheduled scaling for peak learning hours

### 4. **CDN Caching Efficiency**
- Static assets served via CloudFront
- 24-hour cache TTL for CSS/JS/images
- Origin shield reduces origin load

## Expected Savings
- **With optimizations**: ~$400/month (45% reduction)
- **Pay-per-use model** aligns with actual usage
- **Reserved Instances** option for predictable loads

## Monitoring & Alerts
- CloudWatch alarms for cost thresholds
- Weekly cost reports via AWS Cost Explorer
- Anomaly detection for unexpected spikes
