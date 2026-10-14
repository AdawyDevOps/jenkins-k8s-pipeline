# 🚀 Automated CI/CD Pipeline for Containerized Python App on Kubernetes

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.9-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?style=for-the-badge&logo=jenkins&logoColor=white" />
  <img src="https://img.shields.io/badge/Kubernetes-Minikube-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" />
  <img src="https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github&logoColor=white" />
</p>

An enterprise-grade, end-to-end CI/CD pipeline automating the lifecycle of a Python web application—from source code versioning to automated container building, Docker Hub image publishing, and seamless deployment onto a Kubernetes cluster.

---

## 📌 Architecture & Workflow

```mermaid
flowchart LR
    subgraph Developer["👨‍💻 Source Control"]
        A[Git Commit & Push] --> B[(GitHub Repo)]
    end

    subgraph Jenkins["⚙️ CI/CD Server (Docker)"]
        B --> C[Declarative SCM Checkout]
        C --> D[Docker Build Image\n:BUILD_NUMBER]
        D --> E[Docker Login & Push\nDocker Hub]
        E --> F[Inject Image Tag\ninto Manifest]
        F --> G[kubectl Apply Manifests]
    end

    subgraph Registry["🐳 Image Registry"]
        E -.-> H[(Docker Hub Repository)]
    end

    subgraph Kubernetes["☸️ Kubernetes Cluster (Minikube)"]
        G --> I[Deployments & Pods]
        H -.->|Pull Image| I
        I --> J[Service NodePort :30008]
    end

    subgraph EndUser["🌐 User Access"]
        J --> K[End User / Browser]
    end

    style Jenkins fill:#f9f9f9,stroke:#D24939,stroke-width:2px
    style Kubernetes fill:#eef6ff,stroke:#326CE5,stroke-width:2px
    style Developer fill:#f5f5f5,stroke:#333,stroke-width:2px
```

---

## 🛠️ Tech Stack & Prerequisites

* **Application:** Python 3.9 (Flask Web Server).
* **Containerization:** Docker Engine & Dockerfile.
* **Orchestration:** Kubernetes (Minikube).
* **Automation Server:** Jenkins (Running in Docker container).
* **Artifact Registry:** Docker Hub (`adawy123/new-app-nti`).
* **Environment:** Ubuntu (WSL2 / Linux).

---

## 📁 Repository Structure

```text
├── Dockerfile              # Container image specifications
├── Jenkinsfile             # Declarative Jenkins CI/CD pipeline script
├── Python.py               # Main Python application entrypoint
├── req.txt                 # Application dependencies
└── k8s/
    ├── deployment.yaml     # Kubernetes Deployment manifest (dynamic image tag)
    └── service.yaml        # NodePort Service to expose the app
```

---

## ⚙️ Pipeline Stages Breakdown

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Developer
    participant Git as GitHub
    participant Jen as Jenkins
    participant Hub as Docker Hub
    participant K8s as Minikube (K8s)

    Dev->>Git: git push origin main
    Git->>Jen: Trigger Build (SCM Checkout)
    Jen->>Jen: Stage 1: Build Docker Image (${BUILD_NUMBER})
    Jen->>Hub: Stage 2: Push Image (${DOCKER_USERNAME}/${APP_NAME})
    Jen->>Jen: Stage 3: Dynamic sed replacement in deployment.yaml
    Jen->>K8s: Stage 4: kubectl apply Deployment & Service
    K8s->>Hub: Pull new image & start rolling update
```

1. **SCM Checkout:** Automatically clones the latest commit from `main`.
2. **Build Docker Image:** Builds the lightweight Python container image tagged with `${BUILD_NUMBER}`.
3. **Push Docker Image:** Securely authenticates via Jenkins Credentials and publishes the image to Docker Hub.
4. **Deploy to Kubernetes:** 
   * Replaces `IMAGE_PLACEHOLDER` dynamically using `sed`.
   * Applies Deployment and NodePort Service manifests via `kubectl`.

---

## 🔍 Validation & Verification

After the pipeline finishes with `SUCCESS`, verify your deployment:

```bash
# Check Pod status
kubectl get pods -l app=python-app

# Inspect running container image
kubectl describe deployment python-app-deployment | grep Image

# Expose or verify the Service URL
minikube service python-app-service --url
```

---

## 👤 Author
* **Ahmed Ibrahim Adawy** - [GitHub Profile](https://github.com/AdawyDevOps)
