# Directories, configuration and resource creation

## Directory Structure

There are many possibilities on how to distribute your code on the repository, like using workspaces in a single directory, separating directorys per functionality (network, eks, rds etc).

We'll be using the <cloud>/<region>/<environment>/ approach, with all files in a single directory. As we're working only with a simulated AWS environment, we're not adding the <cloud> directory, starting the tree directly with <region>. 

This structure allows things like multi-region, replicated environments:

```
.
├── sa-east-1
│   └── prd
│       └── <terraform files>
└── us-east-1
    ├── dev
    │   └── <terraform files>
    └── prd
        └── <terraform files>
```

As the number of resources in a single directory grows, the time for an `tf plan` may get excessively long. So it may be necessary to change the directory structure to <region>/<environment>/<function>, which will require the use of `terraform_remote_state` resources or tools like `terragrunt`, but this won't be covered here.

## Environment

Each environment must have at least a terraform file with all the configurations regarding the backend and the providers needed,`tf_config.tf` in our case.

For this project this file contains two very important definitions: where the state file will be stored and which role will be used to manage the kubernetes cluster (it's the one created on the setup phase).

* bucket
```
    key            = "us-east-1/dev/terraform.tfstate"
```
Each state file will be saved on it's own directory in the s3 bucket. If we create a new environment or a new region, the path *must* be reflected on the s3 backend key. `terragrunt` allows a seamless configuration, automatically creating the files in the right places but, again, this won't be covered here.

* provider alias and assume role
```
  alias  = "eks-manager"
  assume_role {
    role_arn     = "arn:aws:iam::111111111111:role/EKSClusterAdmin"
    session_name = "terraform-eks"
```

This special configuration creates a new aws provider which will be referred as `eks-manager`. It is necessary on this laboratory because `floci` do not allow the default root user to access the k3s backed EKS simulation.

## Creating the resources

Considering `floci` is up and the initial setup was done, you should be able to run `tf plan` to see which resources will be created and `tf apply` to create them.

* Note: You can access `floci`'s dashboard and effectively see the created resources there, as it were the AWS console. Access `http://localhost:4566/` with your browser and then click `Open Floci UI`


### Connecting to the Kubernetes Cluster

**Prerequisites:**
Before proceeding, ensure that both the AWS CLI (`aws cli`) and `kubectl` are installed and configured on your system.

**1. Update kubeconfig Context:**
To securely connect your local machine to the newly provisioned cluster, run the following command. This updates your local `.kube/config` file with the necessary context credentials:

```bash
aws eks update-kubeconfig \
  --name devops-lab \
  --region us-east-1 \
  --role-arn arn:aws:iam::111111111111:role/EKSClusterAdmin
```

**2. Verification:**
After successfully running the command above, you can verify connectivity and cluster status by executing standard `kubectl` commands. The specific pod names and `AGE` timestamps will vary depending on the time of execution.

**Check Namespaces:**
```bash
$ kubectl get namespaces
NAME              STATUS   AGE
default           Active   21h
kube-node-lease   Active   21h
kube-public       Active   21h
kube-system       Active   21h
```

**List Pods Across All Namespaces:**
```bash
$ kubectl get pods -A -o wide
NAMESPACE     NAME                              READY   STATUS    RESTARTS   AGE   IP          NODE                               NOMINATED NODE   READINESS GATES
kube-system   coredns-57c85bc755-cjxzd          1/1     Running   0          21h   10.42.0.5   i-dcb87a4f17413e3bb.ec2.internal   <none>           <none>
kube-system   metrics-server-5b8c959fb5-8njk8   1/1     Running   0          21h   10.42.0.4   i-dcb87a4f17413e3bb.ec2.internal   <none>           <none>
```

***Note:*** *The hostnames observed in the `NODE` column will adhere to the AWS hostname pattern for `us-east-1`.*
