# Disaster Recovery Plan

## Backup Strategy
- Daily database backups at 2 AM
- Persistent volume snapshots

## Restore Procedure
1. Restore databases from backup
2. Apply Kubernetes manifests
3. Verify all services
