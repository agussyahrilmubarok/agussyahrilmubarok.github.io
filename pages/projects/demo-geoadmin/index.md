---
layout: page
title: GeoAdmin
permalink: /projects/demo-geoadmin
---

# GeoAdmin

**GeoAdmin** is a geographic data administration platform that lets community and local-government teams publish curated places on a public interactive map while managing them through a permission-controlled dashboard. Built with Java Spring Boot microservices, PostgreSQL, MinIO, and a React single-page application, it focuses on clear service boundaries, fine-grained access control, and a reproducible developer experience.

<img src="https://placehold.co/860x400?text=GeoAdmin+Cover" alt="GeoAdmin cover: the public map explorer with a category sidebar shown next to the admin dashboard" class="img-fluid rounded" />

---

## Overview

|                  |                                                                                        |
| ---------------- | -------------------------------------------------------------------------------------- |
| **Role**         | Full-Stack Developer (architecture, backend, frontend, and containerization)           |
| **Type**         | Geographic information platform / Microservices / Single-page application              |
| **Stack**        | Java, Spring Boot, Spring Cloud, PostgreSQL, MinIO, React, TypeScript, Leaflet, Docker |
| **Architecture** | Microservices behind an API gateway, service discovery, stateless JWT-based RBAC       |
| **Deployment**   | Docker Compose, Nginx, Makefile-driven orchestration                                   |
| **Duration**     | [Month Year] - [Month Year]                                                            |
| **Team**         | [Solo project / team size]                                                             |
| **Status**       | Portfolio project (reference implementation)                                           |

---

## Problem & Goals

### Problem

Community and local-government organizations often keep location data, such as public facilities, landmarks, and service points, in spreadsheets and messaging groups. That data is difficult to keep current, impossible to browse visually, and rarely protected by a clear permission model. Teams need a single place where trusted staff can maintain geographic records and where the public can explore them without creating an account.

### Goals

- Publish curated places through a fast public map explorer that requires no sign-in.
- Give administrators one dashboard to manage categories, places, geometries, and imagery.
- Enforce least-privilege access with per-action permissions instead of coarse roles.
- Keep identity, geospatial data, and analytics independently deployable and failure-isolated.
- Provide a reproducible local environment with schema migrations and seed data.

### Constraints

- A self-contained reference implementation with no external identity provider or managed cloud services.
- Geometry stored as GeoJSON in the database rather than a dedicated spatial extension, to keep the stack simple.
- Browser clients consume a stateless API using bearer tokens.

---

## My Contributions

- Designed the service boundaries, API contracts, and database schemas before implementation, and documented each service with OpenAPI.
- Implemented five Spring Boot services: discovery, gateway, identity and access management (IAM), GIS, and analytics.
- Built the authentication and authorization model: JWT issuance, permission-based authorities, and method-level security enforced independently in every service.
- Implemented the GIS domain: categories, places, map settings, search, sorting, pagination, slug generation, and image storage on MinIO.
- Built the React frontend: public map explorer, permission-aware dashboard, and an interactive geometry editor based on Leaflet.
- Containerized the platform with multi-stage Dockerfiles, per-service Compose files, schema-migration containers, and a Makefile for orchestration.
- Conducted a structured post-implementation code and security review and turned the findings into a prioritized hardening roadmap.

---

## Key Features

### Core

- **Public Map Explorer** - Browse categorized places on an interactive map with search, category filtering, and popups that show imagery, address, and a directions link.
- **Category & Place Management** - Create, edit, and remove categories and places, each with an image, description, address, coordinates, and status.
- **Interactive Geometry Editor** - Draw and edit points and polygons directly on the map and persist them as GeoJSON.
- **Map Settings** - Configure the default map center, zoom level, and boundary overlay that the public explorer uses on load.

### Platform

- **Authentication & Authorization** - JWT-based login with 23 granular permissions (for example `map:create`, `user:delete`) grouped into four seeded roles.
- **Analytics Summary** - A dashboard endpoint that aggregates user, role, category, and map counts from multiple services in parallel.
- **Object Storage** - Images are stored in MinIO with generated file names and a size limit.
- **Resilient Edge** - A gateway with per-route circuit breakers, fallback responses, CORS control, and request correlation headers.

---

## Product Walkthrough

<video controls poster="https://placehold.co/860x480?text=GeoAdmin+Walkthrough+Video" class="img-fluid rounded" title="GeoAdmin walkthrough" aria-label="Screen recording that shows a visitor exploring the public map, then an administrator signing in, creating a place, and drawing its geometry">
  <source src="/assets/videos/geoadmin-walkthrough.mp4" type="video/mp4" />
  Your browser does not support the video tag.
</video>

<img src="https://placehold.co/860x480?text=Public+Map+Explorer" alt="Public map explorer showing categorized markers and polygons, a category sidebar with search, and an open place popup with image and directions link" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Admin+Dashboard" alt="Admin dashboard home with summary cards for users, roles, categories, and maps and a permission-aware navigation menu" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Geometry+Editor" alt="Place form with an interactive map where a polygon is being drawn and edited using the drawing toolbar" class="img-fluid rounded" />

<img src="https://placehold.co/860x480?text=Role+and+Permission+Management" alt="Role form listing all available permissions as selectable options for assigning to a role" class="img-fluid rounded" />

---

## Architecture

<img src="https://placehold.co/860x480?text=System+Architecture+Diagram" alt="System architecture diagram: browser, Nginx, API gateway, Eureka discovery, IAM, GIS, and analytics services, PostgreSQL databases, and MinIO object storage" class="img-fluid rounded" />

<pre><code>Browser -&gt; Nginx (SPA) -&gt; API Gateway -&gt; IAM       -&gt; PostgreSQL (iam_db)
                                  -&gt; GIS       -&gt; PostgreSQL (gis_db) + MinIO
                                  -&gt; Analytics -&gt; IAM / GIS (internal endpoints)

All services register with Eureka. The gateway resolves routes via lb://service-name.
</code></pre>

| Component             | Responsibility                                            | Technology                              |
| --------------------- | --------------------------------------------------------- | --------------------------------------- |
| **Discovery**         | Service registry for dynamic routing                      | Spring Cloud Netflix Eureka             |
| **API Gateway**       | Routing, CORS, circuit breakers, request correlation      | Spring Cloud Gateway, Resilience4j      |
| **IAM Service**       | Authentication, users, roles, permissions, token issuance | Spring Boot, Spring Security, JJWT      |
| **GIS Service**       | Categories, places, map settings, image storage           | Spring Boot, Spring Data JPA, MinIO SDK |
| **Analytics Service** | Cross-service aggregation for the dashboard               | Spring Boot, OpenFeign                  |
| **Database**          | One logical database per domain (`iam_db`, `gis_db`)      | PostgreSQL                              |
| **Object Storage**    | Uploaded images with public read access                   | MinIO                                   |
| **Frontend**          | Public explorer and admin dashboard                       | React, TypeScript, Vite, Nginx          |

### Authentication & Request Flow

<img src="https://placehold.co/860x480?text=Authentication+Sequence+Diagram" alt="Sequence diagram of login: browser to gateway to IAM, JWT issued with roles and permissions, then subsequent requests validated locally by each service" class="img-fluid rounded" />

1. The client calls `POST /api/auth/login` through the gateway.
2. IAM verifies the BCrypt-hashed password and issues a signed JWT that carries the user's roles and permissions.
3. The client sends the token as a bearer header on every request.
4. Each service validates the signature locally and converts claims into authorities, so no network call to IAM is needed per request.
5. Method-level rules such as `hasAuthority('map:update')` decide access.

### Key Design Decisions

| Decision                                                      | Rationale                                                    | Trade-off                                                                   |
| ------------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------- |
| Stateless JWT with permissions embedded as claims             | No per-request lookup, so services stay independent and fast | Permission changes and revocation take effect only after token expiry       |
| Shared HMAC signing secret across services                    | Simple local validation in every service                     | Secret distribution and rotation require care; asymmetric keys scale better |
| Authorize by permission, not by role name                     | Roles can be reshaped without code changes                   | Larger permission catalog to govern                                         |
| Logical database per service                                  | Clear data ownership and independent schema evolution        | Cross-domain reads need an API instead of a join                            |
| Analytics through internal endpoints and parallel Feign calls | Aggregates data without sharing databases                    | Adds latency and requires timeouts and failure handling                     |
| GeoAdmin geometry stored as JSON                              | Flexible support for points, polygons, and multi-geometries  | No spatial indexing or database-level geometry validation                   |
| Public-read MinIO bucket for images                           | Simple delivery of images to anonymous visitors              | No per-object access control                                                |
| SQL migrations with schema validation in JPA                  | Schema changes are explicit and reviewable                   | Requires running migrations before services start                           |

---

## Tech Stack

| Layer                 | Technology                                            | Purpose                                             |
| --------------------- | ----------------------------------------------------- | --------------------------------------------------- |
| **Language**          | Java 25, TypeScript                                   | Backend services and frontend                       |
| **Backend Framework** | Spring Boot 4, Spring Security, Spring Data JPA       | REST APIs, security, persistence                    |
| **Cloud Components**  | Spring Cloud Gateway, Eureka, OpenFeign, Resilience4j | Routing, discovery, inter-service calls, resilience |
| **Authentication**    | JWT (HS256) via JJWT                                  | Stateless authentication                            |
| **Database**          | PostgreSQL 18, golang-migrate                         | Relational storage and versioned migrations         |
| **Object Storage**    | MinIO                                                 | Image storage                                       |
| **Frontend**          | React 19, Vite, Ant Design, React Query, Zustand      | UI, server state, client state                      |
| **Mapping**           | Leaflet, Leaflet-Draw                                 | Map rendering and geometry editing                  |
| **API Docs**          | springdoc OpenAPI                                     | Interactive API documentation                       |
| **Container**         | Docker, Docker Compose, Nginx                         | Packaging and runtime                               |
| **Tooling**           | Maven, pnpm, Makefile                                 | Build and orchestration                             |

---

## API Design

The API follows REST conventions with a consistent response envelope, Bean Validation with field-level error messages, server-side pagination, search, and allow-listed sorting. Page size is capped, and image uploads use `multipart/form-data`. Each service publishes an OpenAPI specification through springdoc.

| Method   | Endpoint                 | Description                                                 | Auth             |
| -------- | ------------------------ | ----------------------------------------------------------- | ---------------- |
| `POST`   | `/api/auth/login`        | Authenticate and issue a token                              | Public           |
| `GET`    | `/api/auth/validate`     | Validate a bearer token                                     | Public           |
| `GET`    | `/api/categories/maps`   | Categories with their active places for the public explorer | Public           |
| `GET`    | `/api/settings`          | Default center, zoom, and boundary                          | Public           |
| `GET`    | `/api/maps`              | List places with pagination, search, and sorting            | `map:read`       |
| `POST`   | `/api/maps`              | Create a place with image and geometry                      | `map:create`     |
| `PUT`    | `/api/maps/{id}`         | Update a place                                              | `map:update`     |
| `DELETE` | `/api/maps/{id}`         | Delete a place and its image                                | `map:delete`     |
| `GET`    | `/api/users`             | List users with their roles                                 | `user:read`      |
| `GET`    | `/api/analytics/summary` | Aggregated platform statistics                              | `analytics:read` |

Paginated endpoints return an `items` array and a `meta` object containing `total`, `page`, `size`, `totalPages`, `hasNext`, `hasPrevious`, `search`, `sortBy`, and `sortDirection`.

<details>
<summary>Show example request and response</summary>

<pre><code>POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "&lt;password&gt;"
}
</code></pre>

<pre><code>HTTP/1.1 200 OK

{
  "data": {
    "token": "&lt;jwt&gt;",
    "username": "admin",
    "roles": ["ADMIN"],
    "permissions": ["map:read", "map:create", "map:update", "category:read"]
  }
}
</code></pre>

<pre><code>POST /api/maps
Content-Type: multipart/form-data
Authorization: Bearer &lt;access_token&gt;

name=Community Health Center
categoryId=3
status=ACTIVE
latitude=-6.1951
longitude=106.8341
geometry={"type":"Point","coordinates":[106.8341,-6.1951]}
image=&lt;binary&gt;
</code></pre>

</details>

---

## Data Model

| Database | Table                            | Description                                                     |
| -------- | -------------------------------- | --------------------------------------------------------------- |
| `iam_db` | `users`                          | Accounts and hashed credentials                                 |
| `iam_db` | `roles`, `permissions`           | Role and permission catalog                                     |
| `iam_db` | `user_roles`, `role_permissions` | Many-to-many assignments                                        |
| `gis_db` | `categories`                     | Place groups with color, slug, and image                        |
| `gis_db` | `maps`                           | Places with coordinates, GeoJSON geometry, status, and category |
| `gis_db` | `settings`                       | Default map center, zoom, and boundary                          |

<img src="https://placehold.co/860x500?text=Database+Design+ERD" alt="Entity relationship diagram for iam_db (users, roles, permissions and join tables) and gis_db (categories, maps, settings)" class="img-fluid rounded" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>// iam_db
Table users {
  id bigserial [pk]
  name varchar(100) [not null]
  username varchar(100) [unique, not null]
  email varchar(150) [unique, not null]
  password varchar(255) [not null]
  created_at timestamp
  updated_at timestamp
}

Table roles {
  id bigserial [pk]
  name varchar(100) [unique, not null]
}

Table permissions {
  id bigserial [pk]
  name varchar(100) [unique, not null]
}

Table user_roles {
  user_id bigint [ref: &gt; users.id]
  role_id bigint [ref: &gt; roles.id]
}

Table role_permissions {
  role_id bigint [ref: &gt; roles.id]
  permission_id bigint [ref: &gt; permissions.id]
}

// gis_db
Table categories {
  id bigserial [pk]
  name varchar(100) [not null]
  slug varchar(100) [unique, not null]
  color varchar(20)
  description text
  image varchar(255)
}

Table maps {
  id bigserial [pk]
  name varchar(255) [not null]
  slug varchar(255) [unique, not null]
  description text
  address text
  latitude double
  longitude double
  geometry json [note: 'GeoJSON']
  status varchar(20) [not null]
  image varchar(255)
  category_id bigint [ref: &gt; categories.id, note: 'ON DELETE SET NULL']
}

Table settings {
  id bigserial [pk]
  title varchar(255) [not null]
  description text
  map_center_lat double
  map_center_lng double
  map_zoom int
  village_boundary json
}
</code></pre>

</details>

---

## Security

- **Authentication** - BCrypt password hashing and signed, expiring JWTs issued by a single service.
- **Authorization** - Granular `resource:action` permissions enforced at method level in every service, mirrored in the UI so users only see what they can do.
- **Service-to-Service Calls** - Internal analytics endpoints are excluded from public routing and protected by a shared-secret header.
- **Input Validation** - Bean Validation on request models, allow-listed sort fields, capped page sizes, and parameterized queries through JPA.
- **File Handling** - Uploads are limited in size and renamed with generated identifiers, and path traversal attempts are rejected.
- **Container Hygiene** - Multi-stage builds and non-root runtime users.

---

## Infrastructure & Deployment

| Environment      | Purpose                                  | How It Runs                                                                        |
| ---------------- | ---------------------------------------- | ---------------------------------------------------------------------------------- |
| **Local / Demo** | Full-stack development and demonstration | One Compose file per service on a shared network, started through Makefile targets |

### Build and Run Flow

1. **Infrastructure** - Start PostgreSQL and MinIO, then create the buckets and policies.
2. **Migrations** - Run golang-migrate containers to apply schemas and seed users, roles, permissions, categories, and sample places.
3. **Platform Services** - Start discovery and the gateway.
4. **Domain Services** - Start IAM, GIS, and analytics, each registering itself with Eureka.
5. **Frontend** - Build the React application with the API base URL baked in, and serve it through Nginx.

---

## Observability & Reliability

| Area                    | Approach                                                                                                       |
| ----------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Health Checks**       | Spring Boot Actuator health endpoints and Compose health checks for every service                              |
| **Request Correlation** | A request ID generated at the gateway and passed to downstream services as `X-Request-Id`                      |
| **Resilience**          | Per-route circuit breakers with fallback responses, gateway response timeouts, and Feign connect/read timeouts |
| **Error Handling**      | Consistent JSON error envelope with field-level validation messages                                            |
| **Lifecycle**           | Graceful shutdown and automatic restart policies                                                               |

---

## Challenges & Solutions

| Challenge                                                        | Solution                                                                                                              | Outcome                                                               |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Aggregating statistics across services without sharing databases | Added internal endpoints to IAM and GIS and called them in parallel from the analytics service with explicit timeouts | A single dashboard call without cross-database coupling               |
| Enforcing the same permissions across independent services       | Embedded roles and permissions in the JWT and mapped them to authorities in a shared filter design                    | Consistent, local authorization in every service                      |
| Deleting data that other records depend on                       | Published domain events before deletion so dependent records are checked or detached inside the same transaction      | Referential rules live in the service layer, not only in the database |
| Editing several geometry types in the browser                    | Wrapped Leaflet-Draw in a reusable editor that normalizes drawn shapes into valid GeoJSON                             | One editor supports points, polygons, and multi-polygons              |
| Different API URLs per environment in a static frontend          | Passed the API base URL as a build argument and baked it into the bundle                                              | A reproducible image per target environment                           |

---

## Outcomes

- Delivered a complete vertical slice, from public map to administration, across five independently deployable services and two databases.
- Modeled 23 permissions and four roles, from read-only viewers to super administrators.
- Reduced local setup to a few Makefile commands that provision infrastructure, migrations, seed data, and all services.
- Completed a structured review of the whole codebase that produced a prioritized, actionable hardening plan.

---

## Lessons Learned

- **Design the contract first.** Defining the API, permissions, and schema upfront made the service boundaries easy to maintain.
- **Treat error handling as a feature.** A review showed how a broad catch-all handler can hide framework-level errors, which is why each status code deserves a dedicated test.
- **Reactive and asynchronous code needs explicit context propagation.** Thread-local data such as correlation IDs does not follow requests across threads on its own.
- **Stateless tokens trade control for speed.** They remove lookups, but session lifecycle features such as refresh and revocation must be designed deliberately.
- **Review your own work.** Reading the whole system with a security mindset after building it is one of the highest-value activities in a project.

---

## Roadmap

- Add refresh tokens and token revocation, with login rate limiting at the gateway.
- Validate uploaded images by content type and signature, and serve them with stricter headers.
- Move all secrets to an external secret store and use least-privilege database accounts per service.
- Prevent privilege escalation by restricting which roles and permissions an administrator can grant.
- Add integration tests with Testcontainers and a CI pipeline with build, test, and image scanning stages.
- Add metrics and distributed tracing, and cache the public map and analytics endpoints.
- Publish a consolidated API reference and an updated deployment guide.

---

## Links

|                       |                                                                                 |
| --------------------- | ------------------------------------------------------------------------------- |
| **Source Code**       | [github.com/agussyahrilmubarok/GeoAdmin](https://github.com/agussyahrilmubarok) |
| **Live Demo**         | [demo.example.com](https://example.com)                                         |
| **API Documentation** | [docs.example.com](https://example.com)                                         |
| **Write-up**          | [Medium article](https://medium.com/@agussyahrilmubarok)                        |
