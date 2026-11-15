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

**Disclaimer:** No customizations have been made to the ArgoCD configuration. This setup is for demonstration/lab purposes only and should not be used in a production environment as it is.
