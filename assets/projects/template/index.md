---
layout: page
title: Project Name
permalink: /projects/template
sitemap: false # remove this line when you copy the template for a real project
---

# Project Name

**Project Name** is a [type of system, e.g. event-driven order management backend] that [solves a specific problem] for [target users or business]. Built with [core technologies], it focuses on [two or three qualities, e.g. reliability, scalability, and developer experience].

<img src="https://placehold.co/860x400?text=Project+Cover" alt="Project Name cover" class="img-fluid rounded" />

<!-- Writing guide: keep every section short, use active verbs, and prefer measurable results (numbers, percentages, durations) over adjectives. Delete any section that does not apply, and delete all HTML comments before publishing. -->

---

## Overview

| | |
|---|---|
| **Role** | Backend Engineer |
| **Type** | REST API Platform / Microservices / CI/CD Pipeline |
| **Stack** | Go, PostgreSQL, Redis, Kafka, Docker, Kubernetes |
| **Architecture** | Microservices, event-driven, clean architecture |
| **Deployment** | AWS EKS, GitHub Actions, Terraform |
| **Duration** | January 2025 - June 2025 (6 months) |
| **Team** | 5 members (3 backend, 1 frontend, 1 DevOps) |
| **Status** | In production |

---

## Problem & Goals

### Problem
Describe the business or technical problem in two to four sentences. Explain what was painful before this project existed, such as slow manual processes, a monolith that could not scale, or deployments that took hours.

### Goals
- Reduce [metric] from [baseline] to [target].
- Support [number] concurrent users or [number] requests per second.
- Achieve [availability target, e.g. 99.9%] uptime.
- Enable [capability, e.g. zero-downtime deployments].

### Constraints
- Budget, team size, or deadline limits.
- Legacy systems that had to be integrated.
- Compliance or data residency requirements.

---

## My Contributions

- Designed the REST API contract and database schema, then documented them with OpenAPI before implementation.
- Implemented [service or module], covering [responsibility].
- Built the CI/CD pipeline that reduced deployment time from [X] to [Y].
- Introduced [practice, e.g. structured logging, contract testing, caching] across the team.
- Reviewed pull requests and mentored [number] junior engineers.

---

## Key Features

### Core
- **Feature One** - What it does and why it matters to the user.
- **Feature Two** - What it does and the technical approach behind it.
- **Feature Three** - What it does and the measurable outcome.

### Platform
- **Authentication & Authorization** - JWT with refresh tokens and role-based access control.
- **Background Processing** - Asynchronous jobs through a message queue with retries and dead-letter handling.
- **Audit Logging** - Immutable records of sensitive operations.

---

## Architecture

<img src="https://placehold.co/860x480?text=System+Architecture+Diagram" alt="System architecture diagram" class="img-fluid rounded" />

<pre><code>Client -&gt; API Gateway -&gt; Service A -&gt; PostgreSQL
                       -&gt; Service B -&gt; Redis (cache)
                       -&gt; Kafka -&gt; Worker -&gt; External API
</code></pre>

| Component | Responsibility | Technology |
|---|---|---|
| **API Gateway** | Routing, rate limiting, authentication | Nginx / Kong |
| **Core Service** | Business logic and REST endpoints | Go |
| **Worker** | Asynchronous and scheduled jobs | Go, Kafka |
| **Database** | Primary persistent storage | PostgreSQL |
| **Cache** | Hot data and session storage | Redis |

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Event-driven communication between services | Loose coupling and independent scaling | Eventual consistency and harder debugging |
| PostgreSQL over a NoSQL store | Strong consistency and relational integrity | Vertical scaling limits for writes |
| Redis cache-aside pattern | Lower read latency on hot endpoints | Cache invalidation complexity |

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Language** | Go 1.22 | Backend services |
| **Framework** | Gin / Echo / Spring Boot | HTTP routing and middleware |
| **Database** | PostgreSQL 16 | Relational data storage |
| **Cache** | Redis 7 | Caching and rate limiting |
| **Messaging** | Apache Kafka | Event streaming |
| **Container** | Docker, Kubernetes | Packaging and orchestration |
| **CI/CD** | GitHub Actions | Build, test, and deploy |
| **IaC** | Terraform | Infrastructure provisioning |
| **Monitoring** | Prometheus, Grafana, Loki | Metrics, dashboards, and logs |

---

## API Design

The API follows REST conventions with versioned paths (`/api/v1`), consistent error responses, cursor-based pagination, and an OpenAPI 3 specification.

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/api/v1/auth/login` | Authenticate and issue tokens | Public |
| `GET` | `/api/v1/resources` | List resources with pagination and filters | User |
| `POST` | `/api/v1/resources` | Create a resource | Admin |
| `GET` | `/api/v1/resources/:id` | Retrieve a single resource | User |
| `PATCH` | `/api/v1/resources/:id` | Partially update a resource | Admin |
| `DELETE` | `/api/v1/resources/:id` | Soft delete a resource | Admin |

<details>
<summary>Show example request and response</summary>

<pre><code>POST /api/v1/resources
Content-Type: application/json
Authorization: Bearer &lt;access_token&gt;

{
  "name": "Sample Resource",
  "category": "general"
}
</code></pre>

<pre><code>HTTP/1.1 201 Created

{
  "data": {
    "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
    "name": "Sample Resource",
    "category": "general",
    "created_at": "2025-01-15T08:30:00Z"
  }
}
</code></pre>

</details>

---

## Data Model

| Table | Description |
|---|---|
| `users` | Accounts, credentials, and roles |
| `resources` | Core business entity |
| `audit_logs` | Immutable history of sensitive actions |

<img src="https://placehold.co/860x500?text=Database+Design+ERD" alt="Database design ERD" class="img-fluid rounded" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>Table users {
  id uuid [pk]
  email varchar(150) [unique, not null]
  password_hash varchar(255) [not null]
  role enum('admin', 'user') [default: 'user']
  created_at timestamp
  updated_at timestamp
}

Table resources {
  id uuid [pk]
  owner_id uuid [ref: &gt; users.id]
  name varchar(100) [not null]
  category varchar(50)
  deleted_at timestamp [note: 'Soft delete']
  created_at timestamp
  updated_at timestamp
}
</code></pre>

</details>

---

## Security

- **Authentication** - Short-lived JWT access tokens with rotating refresh tokens.
- **Authorization** - Role-based access control enforced in middleware.
- **Input Validation** - Schema validation on every request and parameterized queries only.
- **Secrets Management** - Environment-based secrets from a vault, never committed to the repository.
- **Transport & Data** - TLS everywhere, passwords hashed with bcrypt or Argon2.
- **Hardening** - Rate limiting, CORS allow-list, security headers, and automated dependency scanning.

---

## Infrastructure & CI/CD

| Environment | Purpose | Deployment Trigger |
|---|---|---|
| **Development** | Integration and feature testing | Merge to `develop` |
| **Staging** | Pre-release validation | Release candidate tag |
| **Production** | Live traffic | Manual approval on tagged release |

### Pipeline Stages
1. **Lint & Format** - Static analysis and code style checks.
2. **Unit & Integration Tests** - Run against ephemeral containers.
3. **Security Scan** - Dependency audit and container image scan.
4. **Build & Push** - Multi-stage Docker build pushed to the registry.
5. **Deploy** - Rolling update to Kubernetes with health checks and automatic rollback.

---

## Observability & Reliability

| Area | Approach |
|---|---|
| **Logging** | Structured JSON logs with correlation IDs, aggregated in Loki |
| **Metrics** | RED metrics (rate, errors, duration) exposed to Prometheus |
| **Dashboards** | Grafana dashboards for latency, throughput, and saturation |
| **Alerting** | Alerts on error rate, p95 latency, and queue lag |
| **Resilience** | Timeouts, retries with backoff, circuit breakers, graceful shutdown |

---

## Testing & Quality

| Type | Tooling | Coverage / Scope |
|---|---|---|
| **Unit** | Go test / JUnit | 80%+ of business logic |
| **Integration** | Testcontainers | Repository and messaging layers |
| **API / Contract** | Postman, Newman | All public endpoints |
| **Load** | k6 | Critical user journeys |

---

## Performance & Scalability

| Metric | Before | After |
|---|---|---|
| **p95 response time** | 850 ms | 120 ms |
| **Throughput** | 200 req/s | 1,500 req/s |
| **Deployment time** | 45 minutes | 6 minutes |
| **Infrastructure cost** | baseline | -30% |

<!-- Replace the numbers above with real measurements, and state how they were measured (tool, environment, dataset size). -->

---

## Challenges & Solutions

| Challenge | Solution | Outcome |
|---|---|---|
| Slow queries on a large table | Added composite indexes and rewrote N+1 queries | p95 latency dropped by 85% |
| Duplicate event processing | Implemented idempotency keys and a deduplication store | Zero duplicate side effects |
| Risky production releases | Introduced blue-green deployment with automated rollback | No release-related downtime |

---

## Results & Impact

- Delivered [outcome] to [number] users or customers.
- Reduced [operational cost or manual effort] by [percentage].
- Maintained [availability] uptime over [period].

---

## Lessons Learned

- What worked well and why.
- What you would do differently next time.
- A technical insight worth sharing with other engineers.

---

## Roadmap

- [ ] Add [planned feature or improvement].
- [ ] Migrate [component] to [better approach].
- [ ] Publish a public API reference.

---

## Links

| | |
|---|---|
| **Source Code** | [github.com/agussyahrilmubarok/project-name](https://github.com/agussyahrilmubarok) |
| **Live Demo** | [demo.example.com](https://example.com) |
| **API Documentation** | [docs.example.com](https://example.com) |
| **Write-up** | [Medium article](https://medium.com/@agussyahrilmubarok) |