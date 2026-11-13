# Kubernetes Configuration Guide

This guide provides the necessary configuration and instructions for managing Kubernetes resources within this environment.

## Remote State Prerequisite

To maintain consistency across infrastructure deployments, all resources must be tracked via a remote state backend. 

The remote state contains all `outputs` from the referenced Terraform state. Any resource managed by the remote state that needs to be utilized must be explicitly exposed via an `output`. Resources will be referenced by the names defined in these outputs, which may differ from the default provider names.

## Kubernetes Provider Configuration

The `kubernetes` provider utilizes information from the `state file` to manage infrastructure components. The `outputs` provide all the necessary metadata to perform this configuration.

Since we are using **Floci**, the `kubernetes` provider must be configured to use the same IAM role as the `aws.manager` provider used during cluster creation. In a production environment, this role is typically associated with specific CI/CD tools and a restricted group of administrators.

# Installed Applications

## ArgoCD

ArgoCD is deployed via `helm` using the `helm_release` resource and exposed via a direct LoadBalancer within the cluster. 

**Note:** Because we are using a simulation of `EKS` via `k3s`, we do not utilize the AWS Load Balancer Controller. Instead, we rely on the standard LoadBalancer implementation provided by the underlying cluster engine.

### Retrieving Credentials and Access Information

Follow these steps to retrieve the default installation password and the LoadBalancer IP address.

#### 1. Retrieve Default Admin Password
Execute the following command to retrieve the initial admin password. If the command does not return a value immediately, wait a few seconds and repeat it until the password is displayed:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

#### 2. Retrieve LoadBalancer IP
Run the following command to obtain the external IP address of the ArgoCD server. If the IP is not yet assigned, wait a few seconds and repeat the command until it appears:

```bash
kubectl get svc argocd-server -n argocd \
  -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' ; echo
```

#### 3. Accessing the Interface
Access the ArgoCD UI via your web browser using the IP address obtained above. Use the following credentials for the initial login:

*   **Username:** `admin`
*   **Password:** The password retrieved in Step 1.

> **Important:** For security reasons, you must change the administrator password immediately after your first successful login.
