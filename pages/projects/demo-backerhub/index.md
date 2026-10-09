---
layout: page
title: BackerHub
permalink: /projects/backerhub
---

# BackerHub

**BackerHub** is a full-stack crowdfunding platform that connects campaign creators with donors through secure, gateway-backed payments. Built with Go, Vue 3, and PostgreSQL, it focuses on payment integrity, secure session management, and a clean, maintainable architecture.

<img src="https://placehold.co/860x400?text=BackerHub+Cover" alt="Cover image: BackerHub landing page showing featured campaigns, category filters, and funding progress bars on desktop and mobile" class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack Engineer |
| **Type** | Crowdfunding Platform (REST API, SPA, Admin Panel) |
| **Stack** | Go, Gin, PostgreSQL, Vue 3, TypeScript, Docker |
| **Architecture** | Clean architecture, layered monolith, gateway abstraction |
| **Deployment** | Docker Compose (local and development environments) |
| **Duration** | [Add duration] |
| **Team** | [Add team size] |
| **Status** | [Add status] |

---

## Problem & Goals

### Problem
Community fundraising needs more than a donation button. Campaigns must be reviewed before they go public, payments arrive asynchronously through third-party gateways that retry and reorder callbacks, and donor money must never be counted twice or lost. Many lightweight implementations treat payment confirmation as a single request/response step, which breaks down as soon as a webhook is delayed, duplicated, or arrives after the payment window has closed.

### Goals
- Deliver an end-to-end journey for donors and creators: discover, donate, pay, and track.
- Support two payment gateways (Midtrans and Xendit) behind one abstraction.
- Keep financial state correct under retries, duplicate callbacks, and concurrent requests.
- Provide a moderated campaign lifecycle with an administrative review workflow.
- Secure the full session lifecycle, including token rotation, device sessions, and revocation.

### Constraints
- Payment confirmation is asynchronous and gateway-specific, with different signature schemes and status vocabularies.
- A single deployable backend serves both the public API and the server-rendered admin panel.
- Core invariants (status transitions, one paid attempt per donation) must hold even if the application layer is bypassed.

---

## My Contributions

- Designed the layered backend architecture and documented it design-first, including a system design document in English, Indonesian, and Japanese.
- Modeled the relational schema and the state machines for campaigns and donations.
- Integrated Midtrans (Snap) and Xendit (Invoice) behind a common `Gateway` interface with a runtime resolver.
- Built the Vue 3 single-page application and the server-rendered admin panel for moderation and analytics.
- Implemented authentication with short-lived JWT access tokens and rotating, hashed refresh tokens.
- Conducted a structured code and security review across authentication, payments, the admin panel, and the frontend, and turned the findings into a prioritized hardening roadmap.

---

## Key Features

### Core
- **Campaign Management** - Creators draft campaigns with a thumbnail, a gallery, a goal, and a deadline, then publish progress updates.
- **Donations & Payments** - Donors pay through Midtrans or Xendit, can donate anonymously, and can leave a message. Each payment attempt is tracked individually.
- **Moderation Workflow** - Admins approve, reject (with a reason), and feature campaigns before and after publication.
- **Community** - Threaded comments and replies on every campaign.
- **Discovery** - Category browsing, featured campaigns, and full-text search tuned for Indonesian.

### Platform
- **Authentication & Authorization** - JWT access tokens, rotating refresh tokens, email verification, password reset, and role-based access (user and admin).
- **Session Management** - Users can review active sessions by device and revoke any or all of them.
- **Admin Analytics** - Dashboard with donation trends, top campaigns, recent donations, and status summaries.
- **Transactional Email** - Verification and password reset emails delivered over SMTP.
- **API Documentation** - Swagger (OpenAPI) specification generated from the handlers.

---

## Product Walkthrough

<img src="https://placehold.co/860x480?text=Demo+Video+Walkthrough" alt="Video placeholder: 90-second walkthrough showing campaign discovery, the donation form, redirect to the payment page, and the donation status updating after payment" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Campaign+Detail+Page" alt="Screenshot placeholder: campaign detail page with image gallery, funding progress, donation form with preset amounts, and comment thread" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Creator+Dashboard" alt="Screenshot placeholder: creator dashboard listing campaigns by status with edit, media upload, and progress update actions" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Admin+Panel" alt="Screenshot placeholder: admin panel dashboard with donation trend chart, top campaigns table, and pending moderation counters" class="img-fluid rounded" />

---

## Architecture

<img src="https://placehold.co/860x480?text=System+Architecture+Diagram" alt="System architecture diagram: Vue SPA and admin browser calling the Go API, which connects to PostgreSQL, an SMTP server, and the Midtrans and Xendit gateways, with gateways calling back through webhooks" class="img-fluid rounded" />

<pre><code>Browser (Vue 3 SPA) -&gt; Nginx (static) 
Browser (SPA)       -&gt; Go API (Gin) -&gt; PostgreSQL
                                     -&gt; SMTP (verification, password reset)
                                     -&gt; Midtrans / Xendit (create transaction)
Midtrans / Xendit   -&gt; Go API /webhooks (signed callbacks) -&gt; PostgreSQL
Admin browser       -&gt; Go API (server-rendered admin panel)
</code></pre>

The backend follows a layered, hexagonal structure: `delivery` (HTTP handlers, middleware, admin controllers) calls `application` (use cases and services), which depends on `domain` (entities, repository interfaces, errors). `infrastructure` (persistence, payment gateways, mail, configuration, server) implements those interfaces and is wired together manually at startup.

| Component | Responsibility | Technology |
|---|---|---|
| **SPA** | Public site, donor and creator dashboards | Vue 3, TypeScript, Vite, Pinia, TanStack Query, Tailwind CSS |
| **Web Server** | Serves the static SPA build | Nginx |
| **API** | REST endpoints, authentication, business logic, webhooks | Go, Gin |
| **Admin Panel** | Moderation, refunds, user and category management, analytics | Server-rendered `html/template`, AdminLTE |
| **Database** | Persistent storage, integrity constraints, triggers | PostgreSQL |
| **Payment Gateways** | Hosted checkout and asynchronous payment confirmation | Midtrans Snap, Xendit Invoice |
| **Mail** | Transactional email | SMTP (Mailpit in development) |
| **File Storage** | Campaign media and avatars | Local volume |

### Payment Flow
1. The donor submits a donation. The API validates the campaign and amount, then creates the donation, requests a hosted checkout from the selected gateway, and records the first payment attempt in a single transaction.
2. The donor is redirected to the gateway-hosted payment page.
3. The gateway sends a signed webhook. The API verifies the signature before touching any data.
4. The matching payment attempt is located and the callback is applied idempotently, so repeated deliveries are harmless.
5. In one transaction, the attempt and the donation transition together, and campaign progress is updated.
6. Failed or expired attempts keep their history. Each new attempt is stored as a separate record.

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Layered architecture with manual dependency injection | Explicit wiring, easy to trace, and infrastructure can be swapped without touching business rules | More boilerplate at the composition root |
| One payment record per gateway attempt | Complete payment history and safe retries | State reconciliation between attempts and donations is more involved |
| `Gateway` interface with a runtime resolver | New providers can be added without changing use cases | Gateway-specific details must be normalized into a shared status model |
| Integrity rules enforced in the database (transition triggers, partial unique indexes) | Correctness holds under concurrency and even if the application layer is bypassed | Business logic is split between code and schema, which requires disciplined migrations |
| Short-lived JWT access tokens with rotating, hashed refresh tokens | Compromised tokens have a small blast radius and sessions can be revoked per device | Extra database access on refresh |
| Server-rendered admin panel inside the same binary | Fewer moving parts and no separate admin deployment | A second authentication path (cookie sessions) to maintain |

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Language** | Go | Backend services |
| **Framework** | Gin | HTTP routing and middleware |
| **Database** | PostgreSQL 18 | Relational data, full-text search, integrity constraints |
| **Data Access** | pgx v5 | Connection pooling and parameterized queries |
| **Frontend** | Vue 3, TypeScript, Vite | Single-page application |
| **State & Data** | Pinia, TanStack Query | Client state and server-state caching |
| **Forms** | vee-validate, Zod | Typed form validation |
| **Styling** | Tailwind CSS | Responsive UI |
| **Admin UI** | AdminLTE, Bootstrap, Chart.js, DataTables | Moderation and analytics |
| **Payments** | Midtrans Snap, Xendit Invoice | Hosted checkout |
| **Container** | Docker, Docker Compose | Packaging and local environments |
| **Mail (dev)** | Mailpit | SMTP capture for local development |
| **API Docs** | Swagger / OpenAPI | Generated API reference |

---

## API Design

The API follows REST conventions with a versioned base path (`/api/v1`), a consistent `message` / `data` / `errors` response envelope, validated payloads, and page-based pagination with an enforced upper limit.

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/api/v1/auth/register` | Register an account and send a verification email | Public |
| `POST` | `/api/v1/auth/login` | Authenticate and issue access and refresh tokens | Public |
| `POST` | `/api/v1/auth/refresh` | Rotate the refresh token and issue a new pair | Refresh token |
| `GET` | `/api/v1/campaigns` | List active campaigns with search, category, and pagination | Public |
| `GET` | `/api/v1/campaigns/{slug}` | Retrieve a campaign by slug | Public |
| `POST` | `/api/v1/donations` | Create a donation and obtain a payment URL | User |
| `GET` | `/api/v1/donations/me/{id}` | Retrieve one of the caller's donations | User |
| `POST` | `/api/v1/donations/{id}/retry` | Start a new payment attempt | User (owner) |
| `POST` | `/api/v1/webhooks/midtrans` | Receive Midtrans payment notifications | Signature |
| `POST` | `/api/v1/webhooks/xendit` | Receive Xendit invoice callbacks | Callback token |

<details>
<summary>Show example request and response</summary>

<pre><code>POST /api/v1/donations
Content-Type: application/json
Authorization: Bearer &lt;access_token&gt;

{
  "campaign_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "amount": 100000,
  "message": "Good luck with the campaign!",
  "is_anonymous": false,
  "gateway": "midtrans"
}
</code></pre>

<pre><code>HTTP/1.1 201 Created

{
  "message": "Donation created",
  "data": {
    "id": "b1e4c3f2-9a50-4d1c-8d8e-2f6a1c0b7e11",
    "order_id": "DON-1767225600-1a2b3c4d",
    "status": "pending",
    "payment_url": "https://app.sandbox.midtrans.com/snap/v4/redirection/..."
  }
}
</code></pre>

The payload above is abbreviated for illustration.

</details>

---

## Data Model

| Table | Description |
|---|---|
| `users` | Accounts, credentials, roles, and hashed verification and reset tokens |
| `refresh_tokens` | Hashed refresh tokens with expiry, revocation, and device metadata |
| `categories` | Campaign categories |
| `campaigns` | Campaign content, goal, progress, status, and moderation fields |
| `campaign_images` | Ordered gallery images |
| `campaign_updates` | Progress updates posted by the creator |
| `comments` | Threaded comments with soft deletion |
| `donations` | The donor's pledge and its lifecycle status |
| `payment_donations` | One row per gateway payment attempt |

<img src="https://placehold.co/860x500?text=Database+Design+ERD" alt="Entity relationship diagram showing users, campaigns, donations, and payment_donations with their foreign key relationships" class="img-fluid rounded" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>Table users {
  id uuid [pk]
  name varchar(100) [not null]
  email varchar(150) [not null, note: 'Case-insensitive unique among active users']
  password_hash varchar(255) [not null]
  role enum('admin', 'user') [default: 'user']
  is_email_verified boolean [default: false]
  deleted_at timestamp [note: 'Soft delete']
  created_at timestamp
  updated_at timestamp
}

Table refresh_tokens {
  id uuid [pk]
  user_id uuid [ref: &gt; users.id]
  token_hash varchar(255) [unique, not null]
  expires_at timestamp [not null]
  revoked_at timestamp
  user_agent varchar(255)
  ip_address varchar(45)
}

Table campaigns {
  id uuid [pk]
  user_id uuid [ref: &gt; users.id]
  category_id uuid [ref: &gt; categories.id]
  title varchar(150) [not null]
  slug varchar(200) [not null]
  goal_amount bigint [not null]
  collected_amount bigint [default: 0]
  backer_count int [default: 0]
  status enum('draft', 'active', 'completed', 'failed', 'rejected')
  deadline_at timestamp [not null]
  is_featured boolean [default: false]
  deleted_at timestamp [note: 'Soft delete']
}

Table donations {
  id uuid [pk]
  campaign_id uuid [ref: &gt; campaigns.id]
  user_id uuid [ref: &gt; users.id]
  order_id varchar(64) [unique, not null]
  amount bigint [not null]
  is_anonymous boolean [default: false]
  status enum('pending', 'paid', 'failed', 'expired', 'refunded')
  paid_at timestamp
}

Table payment_donations {
  id uuid [pk]
  donation_id uuid [ref: &gt; donations.id]
  gateway enum('midtrans', 'xendit')
  gateway_transaction_id varchar(100)
  status enum('pending', 'paid', 'failed', 'expired', 'refunded')
  amount_received bigint
  raw_payload jsonb [note: 'Gateway notification kept for audit']
  expired_at timestamp
}
</code></pre>

</details>

---

## Security

- **Authentication** - HMAC-signed JWT access tokens (15-minute lifetime) with algorithm pinning and mandatory issuer, audience, and expiry validation.
- **Session Management** - Refresh tokens are 256-bit random values stored only as hashes, rotated on every use, tracked per device, and revocable individually or all at once. Password resets revoke all sessions.
- **Credentials** - Passwords are hashed with bcrypt. Email verification and password reset tokens are stored as hashes with expiry.
- **Webhook Verification** - Midtrans notifications are verified with a SHA-512 signature and Xendit callbacks with a callback token, both using constant-time comparison before any processing.
- **Input Handling** - Schema validation on request payloads and parameterized queries throughout the data layer.
- **File Uploads** - Content-type sniffing instead of trusting file extensions, UUID-based file names, and a 5 MB size limit.
- **Abuse Protection** - Rate limiting on authentication endpoints and a configurable CORS policy.
- **Admin Access** - Role verified against the database on every admin request, with cookie-based sessions kept separate from API tokens.

---

## Infrastructure & Environments

| Environment | Purpose | How It Runs |
|---|---|---|
| **Local (full stack)** | End-to-end development and demos | Docker Compose: PostgreSQL, Mailpit, backend, frontend |
| **Backend development** | Fast iteration on the Go API | Compose runs only dependencies; the API runs on the host with hot reload |
| **Production** | Live traffic | Container images with configuration and secrets supplied through environment overrides |

### Delivery Pipeline (Target State)
1. **Lint & Format** - Static analysis for Go and TypeScript.
2. **Unit & Integration Tests** - Run against ephemeral PostgreSQL containers.
3. **Security Scan** - Dependency audit and container image scan.
4. **Build & Push** - Multi-stage image builds pushed to a registry.
5. **Deploy** - Rolling update with health checks and automatic rollback.

---

## Observability & Reliability

| Area | Approach |
|---|---|
| **Logging** | Structured logs with per-request correlation IDs |
| **Health** | Dedicated health endpoint for orchestration probes |
| **Shutdown** | Graceful shutdown that drains in-flight requests |
| **Payments** | Transactional, idempotent webhook handling with database-level safeguards |
| **Configuration** | YAML configuration with environment variable overrides |

---

## Testing & Quality

| Type | Tooling | Scope |
|---|---|---|
| **Static Typing** | `vue-tsc` | Strict type checking across the frontend |
| **Build Verification** | Vite production build | Frontend compiles and bundles cleanly |
| **Test Doubles** | Mockery | Generated mocks for repositories and services |
| **API Contract** | Swagger / OpenAPI | Generated reference for all public endpoints |
| **Unit & Integration** | Go test, Testcontainers | Planned: payment, webhook, and session flows |

---

## Performance Considerations

| Area | Approach |
|---|---|
| **Search** | PostgreSQL full-text search with an Indonesian configuration and a dedicated GIN index |
| **Listings** | Composite index on category, status, and creation time for browse queries |
| **Pagination** | Enforced page-size ceiling and a single query for rows plus total count |
| **Connections** | Pooled database connections with parameterized queries |
| **Client Caching** | TanStack Query caching and request de-duplication on the frontend |
| **Token Refresh** | Single-flight refresh so concurrent requests share one token rotation |

---

## Challenges & Solutions

| Challenge | Solution | Outcome |
|---|---|---|
| Gateways retry, duplicate, and reorder callbacks | Idempotency guard, single-transaction updates, a transition trigger, and a partial unique index allowing one paid attempt per donation | Replayed callbacks cannot double-apply a payment |
| Two gateways with different signatures and statuses | Common `Gateway` interface with normalized notification results | New providers plug in without touching use cases |
| Retrying a payment without losing history | One payment record per attempt linked to a single donation | Full audit trail and safe retries |
| Safe session lifecycle across devices | Hashed, rotating refresh tokens with a session management screen | Per-device revocation and bounded token exposure |
| Keeping uploaded files consistent with database writes | Compensating file cleanup when a database update fails | No orphaned files after failed uploads |
| Concurrent requests during token expiry | Single-flight refresh interceptor with a request queue | One refresh per expiry window, and network errors do not log users out |

---

## Delivery Summary

- Delivered three connected interfaces: a public SPA, a creator dashboard, and an administrative panel.
- Roughly 13,000 lines of Go and 8,000 lines of TypeScript and Vue across a nine-table relational schema.
- Integrated two payment gateways behind a single abstraction.
- Produced a trilingual system design document and a prioritized hardening roadmap from a full code and security review.

---

## Lessons Learned

- Keep derived financial data, such as campaign totals, in a single place. Updating it from both database triggers and application code invites double counting.
- Treat webhooks as an inbox: persist the raw payload before processing so late or rejected notifications can always be reconciled.
- Design scheduled work (payment expiry, campaign finalization, token cleanup) together with the data model, not after it.
- Centralize reactive-parameter handling in frontend data hooks and cover it with tests, because type checking alone does not catch URL construction mistakes.

---

## Roadmap

- Add an automated test suite for payment, webhook, and session flows, and run it in CI.
- Schedule maintenance jobs for payment expiry, campaign finalization, and refresh token cleanup.
- Introduce a webhook inbox with reconciliation for late or rejected payment notifications.
- Process refunds through the gateway APIs and notify donors.
- Add CSRF protection, rate limiting, and subresource integrity to the admin panel.
- Ship database migrations alongside the code so the full stack starts from a clean checkout.
- Add metrics and dashboards (request rate, errors, latency) and a deployment pipeline.
- Publish a public API reference.

---

## Links

| | |
|---|---|
| **Source Code** | [github.com/agussyahrilmubarok/backerhub](https://github.com/agussyahrilmubarok) |
| **Live Demo** | [demo.example.com](https://example.com) |
| **API Documentation** | [docs.example.com](https://example.com) |
| **Write-up** | [Medium article](https://medium.com/@agussyahrilmubarok) |
