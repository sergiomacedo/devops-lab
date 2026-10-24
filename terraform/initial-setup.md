# Initial Setup Guide

## Terraform State Backend

When provisioning any new infrastructure using Terraform (or Tofu), establishing a secure and reliable backend storage mechanism is a critical first step for tracking resource state.

In this setup, we define an Amazon S3 bucket to host the remote state files and utilize DynamoDB to ensure atomic locking consistency across concurrent deployments.

**Best Practice Notice:**
Storing remote state in services like S3 is strongly recommended. Committing local `terraform.state` files directly to a Git repository should not be done at all.


## Initial AWS IAM Setup

Floci does not implement all api calls for EKS clusters management and does not allow the default root user to login into k3s, which is the backend that simulates an EKS cluster.

To avoid a "chicken-and-egg" situation when creating the EKS cluster, we need to setup a new user and its policy in advance.

In a real environment, the options provided by the AWS EKS terraform module will create the necessary roles and policies.

## Directory Structure (`terraform/setup`)
**Tool Alias Note:** For simplicity throughout this guide, we will use the abbreviation `tf` to refer generically to both Terraform and Tofu. The operational workflow remains identical regardless of which tool you are using. We recommend setting up an alias for `tf` pointing to your preferred installed utility.

The standard operational procedure requires navigating into the setup directory:
1.  **Prerequisite:** Verify that the Floci service is running (this is a mandatory prerequisite).
2.  **Plan:** Change directory and run `tf plan` within the `./setup` directory. This validates the configuration and checks for potential misconfigurations against your target infrastructure without making changes.
3.  **Apply:** Change directory and execute `tf apply` within the `./setup` directory. This provisions the resources defined in your code to the remote backend.
4.  **Check:** After applying you can verify the bucket creation with `aws s3 ls`
