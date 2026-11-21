# Kubernetes Configuration Guide

This guide describes the configuration and procedures used to manage Kubernetes resources in this environment.

## Remote State Prerequisite

To maintain consistency across infrastructure deployments, all resources must be tracked through a remote state backend.

The remote state contains the `outputs` from the referenced Terraform state. Any remote-state resource that another configuration needs to use must be explicitly exposed through an `output`. Resources are referenced by the names defined in those outputs, which may differ from the provider's default resource names.

## Kubernetes Provider Configuration

The `kubernetes` provider uses information from the state file to manage infrastructure components. The `outputs` provide the metadata required for this configuration.

Because this environment uses **Floci**, the `kubernetes` provider must use the same IAM role as the `aws.manager` provider used during cluster creation. In production, this role is typically associated with a specific CI/CD system and a restricted group of administrators.

## Installed Applications

### Traefik

Traefik is an Ingress and reverse-proxy solution used to route external traffic to applications running in the cluster.

It exposes the applications through a single IP address while using different hostnames to route requests to the appropriate service.

Traefik is deployed with Helm using the `helm_release` Terraform resource. Retrieve the address of its LoadBalancer service with:

```bash
kubectl get svc -n traefik
NAME      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
traefik   LoadBalancer   10.100.42.209   172.17.0.3    80:30994/TCP,443:30278/TCP   14m
```

You can also retrieve an internal node address with:

```bash
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'; echo
172.17.0.3
```

The addresses in this guide are examples. Retrieve the current values for your environment before proceeding.

**Note:** Because this environment simulates EKS with k3s, it does not use the AWS Load Balancer Controller. Instead, it relies on the standard LoadBalancer implementation provided by the underlying cluster engine.

### ArgoCD

ArgoCD is deployed with Helm using the `helm_release` Terraform resource. It is exposed through an Ingress resource managed by Traefik as `argocd.local`. 

To access it from your browser, you must add this line to your `/etc/hosts`, updating the IP address for the one that matches your system:
```
172.17.0.3 argocd.local
```


**Disclaimer:** Insecure configurations are used for these applications. This setup is for demonstration and laboratory purposes only and must not be used as-is in production.
