# ArgoCD Configuration

## Retrieving Credentials and Access Information

Follow the steps below to retrieve the default administrator password and configure the ArgoCD provider.

### 1. Retrieve Default Admin Password

Execute the following command to retrieve the initial administrator password. If the command does not return a value immediately, wait a few seconds and repeat it until the password is displayed:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

### 2. Accessing the Interface

Access the ArgoCD interface in a web browser at `https://argocd.local`. Use the following credentials for the initial login:

- **Username:** `admin`
- **Password:** The password retrieved in Step 1.

> **Important:** In a production environment, for security reasons, you must change the administrator password immediately after your first successful login.

### 3. Obtaining the API Key

After logging in as `admin`, open **Accounts**, select the `devops-lab` account created in [argocd.tf](../k8s-platform/argocd.tf), and generate a new token.

### 4. Configuring the provider in `tf_config.tf`

```hcl
provider "argocd" {
  server_addr = "argocd.local"
  auth_token  = "ApiToken from Step 3"
}
```

In production, this token should be available to Atlantis or another CI/CD tool used to provision and manage the infrastructure.

## Managing Applications in ArgoCD

There are two approaches to configuring application management in a production environment:

- Each application in ArgoCD points to its own repository and retrieves all of its configuration from that repository.
- All application configurations, including Helm `values.yaml` files, are stored in a single repository.

The first approach is easier to maintain, but ArgoCD has historically encountered scaling problems when more than 50 applications point to different repositories. The second approach is more stable as the number of applications grows, but it is more complex to configure reliably, especially when updating application image versions.

This configuration creates a sample ArgoCD `Application` resource through Terraform and points it to another directory inside this repository, where the application configuration will be stored.

This ArgoCD instance is configured to work with the provisioned Kubernetes cluster. Consult the ArgoCD documentation to learn how to connect additional clusters.

In this laboratory we'll follow the second approach, adding the values for each application under directory `apps/` in this same repository.