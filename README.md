# terraform-ecs-multi-env-infra

📖 Overview

This project demonstrates a practical DevOps implementation of deploying a containerized web application (FastAPI backend and Next.js frontend) on AWS using Terraform as Infrastructure as Code (IaC).
The infrastructure is designed with a modular and multi-environment structure (dev, staging, production) and includes services such as Amazon ECS for container orchestration, Amazon ECR for image storage, load balancing, and networking configuration.
The goal of this project is to showcase hands-on experience in cloud infrastructure provisioning, containerization, environment management, and infrastructure automation following DevOps best practices.

The architecture is designed with:

-Multi-environment support (Development, Staging, Production)

-Amazon ECS (Fargate) for container orchestration

-Application Load Balancer (ALB)

-Auto Scaling with CloudWatch monitoring

-Amazon ECR for container image storage

-Modular Terraform architecture

-High availability and secure networking

-This project demonstrates real-world cloud infrastructure implementation aligned with DevOps best practices.

## Project Structure

```
terraform-ecs-multi-env-infra/
│
├── backend/                    # FastAPI application
│   ├── app/
│   └── requirements.txt
│
├── frontend/                   # Next.js application
│   ├── pages/
│   └── package.json
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── alb/
│   │   ├── ecs-cluster/
│   │   ├── ecs-service/
│   │   ├── ecr/
│   │   └── autoscaling/
│   │
│   └── environments/
│       ├── dev/
│       ├── staging/
│       └── prod/
│
└── README.md
```

## Prerequisites

- Python 3.8+
- Node.js 16+
- npm or yarn

## Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Run the FastAPI server:
   ```bash
   uvicorn app.main:app --reload --port 8000
   ```

   The backend will be available at `http://localhost:8000`

## Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   yarn
   ```

3. Configure the backend URL (if different from default):
   - Open `.env.local`
   - Update `NEXT_PUBLIC_API_URL` with your backend URL
   - Example: `NEXT_PUBLIC_API_URL=https://your-backend-url.com`

4. Run the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

   The frontend will be available at `http://localhost:3000`

## Changing the Backend URL

To change the backend URL that the frontend connects to:

1. Open the `.env.local` file in the frontend directory
2. Update the `NEXT_PUBLIC_API_URL` variable with your new backend URL
3. Save the file
4. Restart the Next.js development server for changes to take effect

Example:
```
NEXT_PUBLIC_API_URL=https://your-new-backend-url.com
```

## For deployment:
   ```bash
   npm run build
   # or
   yarn build
   ```

   AND

   ```bash
   npm run start
   # or
   yarn start
   ```

   The frontend will be available at `http://localhost:3000`

## Testing the Integration

1. Ensure both backend and frontend servers are running
2. Open the frontend in your browser (default: http://localhost:3000)
3. If everything is working correctly, you should see:
   - A status message indicating the backend is connected
   - The message from the backend: "You've successfully integrated the backend!"
   - The current backend URL being used

## API Endpoints

- `GET /api/health`: Health check endpoint
  - Returns: `{"status": "healthy", "message": "Backend is running successfully"}`

- `GET /api/message`: Get the integration message
  - Returns: `{"message": "You've successfully integrated the backend!"}`


## Docker & ECR Workflow

The frontend and backend are containerized using Docker.

### Build Images

```bash
docker build -t dev/backend backend/
docker build -t dev/frontend frontend/
```

### Authenticate with Amazon ECR

```bash
aws ecr get-login-password --region us-west-2 | \
docker login --username AWS --password-stdin (accountID).dkr.ecr.us-west-2.amazonaws.com
```

### Tag Image

```bash
docker tag dev/backend:latest (accountID).dkr.ecr.us-west-2.amazonaws.com/prod/backend:latest
```

### Push Image

```bash
docker push (accountID).dkr.ecr.us-west-2.amazonaws.com/prod/backend:latest
```
### Repeat the same process for the staging and prod.
ECS services pull container images directly from ECR.


Infrastructure Deployment:
### 1.Navigate to Environment
```bash
cd terraform/environments/dev
```
### 2.Initialize Terraform
``` bash
terraform init
 ```
### 3.Plan Infrastructure
``` bash 
terraform plan
 ```
### 4.Apply Infrastructure
``` bash
terraform apply
 ```
### Repeat the same process for:
staging
prod

**📈 Auto Scaling Configuration**
1.Scaling Metric: CPU Utilization

2.Target Value: ~60%

3.Minimum Tasks: Configurable per environment

4.Maximum Tasks: Configurable per environment

5.Monitoring: CloudWatch alarms trigger scaling policies automatically

**🔐 Security Design**
1.ECS tasks deployed in private subnets

2.Only Application Load Balancer (ALB) exposed to the internet

3.Security groups restrict internal communication

4.No public EC2 instances

5.Serverless compute using AWS Fargate

6.Environment-level isolation

