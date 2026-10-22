# Floci Lab - Local AWS Services Emulator Setup

This directory contains the configuration needed to run Floci, a local emulator for AWS services and container orchestration, allowing you to test workflows without needing live cloud credentials or incurring costs.

## 🚀 Getting Started

### Step 1: Start Floci using Docker Compose
We use the provided `docker-compose.yml` to spin up all required services (including the local cluster engine).

1.  **Run the stack:**
    ```bash
    docker compose up -d
    ```

2.  **Verify status:**
    Wait a few minutes for all containers to initialize. You can check the logs:
    ```bash
    docker compose logs floci
    ```

### Step 2: Configure AWS Credentials for Floci Endpoint

To ensure that your local tools (like `aws cli`, Python SDKs) communicate with the local Floci emulator (`http://localhost:4566`) and not the real Amazon cloud, you must configure the environment and credentials.

#### A. Set Environment Variables (Recommended Method)
Setting these variables in your current shell session is the most reliable way to redirect all traffic:
```bash
export AWS_ENDPOINT_URL="http://localhost:4566"
# Optional: Define a default region if needed for testing consistency
export AWS_DEFAULT_REGION="us-east-1" 
```

#### B. Configure `~/.aws/config` (If environment variables are ignored)
For some applications, you may need to explicitly set the endpoint in your AWS configuration file located at `~/.aws/config`.

Add or modify the relevant profile section:
```ini
[default]
region = us-east-1
# This directs all AWS services to use the local Floci emulator
endpoint_url = http://localhost:4566
```

#### C. Configure `~/.aws/credentials` (Template)
This file should contain placeholder test credentials for multiple AWS accounts. The `[profile]` section name specifies the account ID (e.g., [account-1]). You can create new profiles with different Access Key IDs to simulate connecting to different AWS accounts or environments. **IMPORTANT:** All `aws_access_key_id` values MUST be 12 digits long, simulating a real AWS Account ID.

**File:** `~/.aws/credentials`

```ini
[default]
aws_access_key_id = 111111111111
aws_secret_access_key = test
```

---
## 💡 Tips
*   **Stopping Floci:** When finished, stop the services with: `docker compose down`
*   **Accessing Local Cluster:** Once configured, your tools should be able to interact with the local cluster engine provided by Floci.