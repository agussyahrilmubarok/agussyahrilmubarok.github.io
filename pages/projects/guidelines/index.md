---
layout: page
title: Guidelines
permalink: /projects/guidelines
---

# Guidelines

A living style reference for writing and formatting content across all project pages. Use this as a reference when creating new project documentation.

<p class="text-muted">Last updated: April 2025</p>

---

## Table of Contents

- [Typography](#typography)
- [Paragraph](#paragraph)
- [Emphasis](#emphasis)
- [Blockquote](#blockquote)
- [Links](#links)
- [Images](#images)
- [Lists](#lists)
- [Tables](#tables)
- [Code](#code)
- [Badge](#badge)
- [Divider](#divider)

---

## Typography

This project uses two fonts:

- **Plus Jakarta Sans** — used for headings (h1–h6)
- **Inter** — used for body text, paragraphs, and UI elements

### Heading Scale

# H1 — Page Title (2rem, weight 700)
## H2 — Section Title (1.5rem, weight 700)
### H3 — Subsection (1.17rem, weight 600)
#### H4 — Sub-subsection (1rem, weight 600)
##### H5 — Small heading (0.9rem, weight 600)
###### H6 — Smallest heading (0.8rem, weight 600)

### When to use each heading

Use **H1** only once per page as the page title. Use **H2** for major sections. Use **H3** for subsections within a section. Use **H4–H6** sparingly for deeply nested content.

---

## Paragraph

### Single paragraph

A paragraph is a block of text separated by a blank line. Keep paragraphs focused on one idea. Avoid overly long paragraphs — aim for 3 to 5 sentences per block for readability.

### Multiple paragraphs

First paragraph. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

Second paragraph. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Third paragraph. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante.

### Line break

Use `<br>` for a soft line break without starting a new paragraph.<br>
This line follows immediately after a line break.<br>
Useful for addresses, step-by-step short lines, or poetry.

### Muted paragraph

<p class="text-muted">This is muted text. Use for dates, captions, secondary info, and footnotes.</p>

<p class="text-muted"><i>Released on January 2025 · Status: Completed</i></p>

### Small text

<small>This is small text. Use for fine print, version numbers, or legal notes.</small>

---

## Emphasis

Normal text for regular content.

**Bold text** — use for important terms, key concepts, or strong emphasis.

*Italic text* — use for book titles, foreign words, technical terms, or soft emphasis.

***Bold and italic*** — use sparingly for critical warnings or maximum emphasis.

~~Strikethrough~~ — use for deprecated features, removed content, or corrections.

`inline code` — use for commands, file names, variable names, and short code snippets.

Combining emphasis: **Install** `docker` and `docker-compose` before proceeding. See the *official documentation* for details.

---

## Blockquote

### Single line

> This is a single line blockquote. Use for short quotes or callout notes.

### Multi line

> This is a multi-line blockquote. Use for longer quotes, thesis titles, book references, or important notes that need to stand out from the body text. Keep blockquotes concise and relevant to the surrounding content.

### Nested blockquote

> Outer blockquote — main context or original source.
>
> > Inner blockquote — a reply, clarification, or nested reference.

### Blockquote with attribution

> The only way to do great work is to love what you do.
>
> — *John Appleseed, Design Engineer*

---

## Links

### Inline link

Visit [Go official website](https://go.dev/) for documentation and downloads.

Read more about [Docker Compose](https://docs.docker.com/compose/) in the official docs.

### Reference link

This project uses [Kratos][kratos] as the microservice framework and [PostgreSQL][postgres] as the primary database.

[kratos]: https://go-kratos.dev/
[postgres]: https://www.postgresql.org/

### External link

<a href="https://go.dev/" target="_blank">Go — opens in new tab</a>

### Email link

Contact us at <a href="mailto:hello@example.com">hello@example.com</a>

### Marker link style

<div class="marker-link">
  <a href="#">This link uses the marker highlight style on hover</a>
</div>

### No marker link style

<div class="no-marker-link">
  <a href="#">This link has no marker highlight — plain style</a>
</div>

---

## Images

### Basic image

![Placeholder image](https://placehold.co/860x300)

### Small image with rounded corners

<img src="https://placehold.co/100x100" class="rounded" width="100" height="100" alt="App icon — 100x100">

### Medium image

<img src="https://placehold.co/400x200" class="rounded" width="400" height="200" alt="Medium image — 400x200">

### Full width image

<img src="https://placehold.co/860x400" width="100%" alt="Full width banner — 860x400">

### Image with caption

<figure>
  <img src="https://placehold.co/860x300" width="100%" alt="Architecture diagram">
  <figcaption>Figure 1 — System architecture overview showing the relationship between services.</figcaption>
</figure>

### Image side by side

<div style="display:flex; gap:16px;">
  <img src="https://placehold.co/200x200" class="rounded" width="200" height="200" alt="Screenshot 1">
  <img src="https://placehold.co/200x200" class="rounded" width="200" height="200" alt="Screenshot 2">
  <img src="https://placehold.co/200x200" class="rounded" width="200" height="200" alt="Screenshot 3">
</div>

### App icon size (used in projects list)

<img src="https://placehold.co/100x100" class="rounded" width="100" height="100" alt="App icon">

---

## Lists

### Unordered list

- First item in the list
- Second item in the list
- Third item in the list
- Fourth item in the list

### Ordered list

1. Clone the repository
2. Install dependencies with `go mod download`
3. Copy `.env.example` to `.env` and fill in values
4. Run `docker compose up -d`
5. Access the app at `http://localhost:8080`

### Nested unordered list

- Backend
  - Language: Go, Python
  - Framework: Gin, Kratos
  - Database: PostgreSQL, MongoDB, Redis
- Mobile
  - Language: Kotlin, Dart
  - Framework: Jetpack Compose, Flutter
  - Services: Firebase, Google Maps SDK
- DevOps
  - Container: Docker, Kubernetes
  - Cloud: AWS, GCP, Azure
  - IaC: Terraform, Ansible

### Nested ordered list

1. Setup environment
   1. Install Go 1.22+
   2. Install Docker Desktop
   3. Install kubectl
2. Clone and configure
   1. Clone the repository
   2. Copy `.env.example` to `.env`
   3. Set required environment variables
3. Run the application
   1. Start with `docker compose up -d`
   2. Check logs with `docker compose logs -f`
   3. Access at `http://localhost:8080`

### Mixed list

- **Prerequisites**
  1. Go 1.22 or higher
  2. Docker and Docker Compose
  3. PostgreSQL 15+
- **Optional**
  1. kubectl for Kubernetes deployment
  2. Terraform for infrastructure provisioning

### Task list

- [x] Setup project structure
- [x] Implement REST API
- [x] Add database migrations
- [x] Write unit tests
- [ ] Add integration tests
- [ ] Deploy to production
- [ ] Write documentation

---

## Tables

### Basic table

| Name | Value |
|---|---|
| Language | Go |
| Framework | Kratos |
| Database | PostgreSQL |
| Cache | Redis |

### Full table

| Component | Technology | Version | Status |
|---|---|---|---|
| Backend | Go | 1.22 | Active |
| Framework | Kratos | v2 | Active |
| Database | PostgreSQL | 15 | Active |
| Cache | Redis | 7 | Active |
| Message Broker | Kafka | 3.6 | Active |
| Container | Docker | 24 | Active |
| Orchestration | Kubernetes | 1.28 | Active |
| Monitoring | Prometheus | 2.48 | Active |
| Dashboard | Grafana | 10 | Active |

### Left aligned (default)

| Endpoint | Method | Description |
|---|---|---|
| `/api/v1/users` | GET | List all users |
| `/api/v1/users/:id` | GET | Get user by ID |
| `/api/v1/users` | POST | Create new user |
| `/api/v1/users/:id` | PUT | Update user by ID |
| `/api/v1/users/:id` | DELETE | Delete user by ID |

### Table with inline code

| Variable | Type | Default | Description |
|---|---|---|---|
| `DB_HOST` | string | `localhost` | Database host |
| `DB_PORT` | int | `5432` | Database port |
| `DB_NAME` | string | `mydb` | Database name |
| `DB_USER` | string | `postgres` | Database user |
| `DB_PASS` | string | `secret` | Database password |
| `APP_PORT` | int | `8080` | Application port |
| `LOG_LEVEL` | string | `info` | Log level |

---

## Code

### Inline code

Run `go mod tidy` to clean up dependencies.

Use `kubectl get pods -n production` to check pod status.

The config file is located at `~/.config/app/config.yaml`.

### Bash
```bash
# Clone repository
git clone https://github.com/example/project.git
cd project

# Install dependencies
go mod download

# Copy environment file
cp .env.example .env

# Run with Docker
docker compose up -d

# Check logs
docker compose logs -f app
```

### Go
```go
package main

import (
    "context"
    "log"
    "net/http"
)

type Server struct {
    addr string
    mux  *http.ServeMux
}

func NewServer(addr string) *Server {
    return &Server{
        addr: addr,
        mux:  http.NewServeMux(),
    }
}

func (s *Server) Run(ctx context.Context) error {
    s.mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte(`{"status":"ok"}`))
    })
    log.Printf("Server running at %s", s.addr)
    return http.ListenAndServe(s.addr, s.mux)
}

func main() {
    srv := NewServer(":8080")
    if err := srv.Run(context.Background()); err != nil {
        log.Fatal(err)
    }
}
```

### Kotlin
```kotlin
@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private val viewModel: MainViewModel by viewModels()
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        observeUiState()
    }

    private fun observeUiState() {
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.uiState.collect { state ->
                    binding.textView.text = state.message
                }
            }
        }
    }
}
```

### YAML
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=mydb
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: secret
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### Dockerfile
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/server

FROM alpine:3.19
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8080
USER nobody
CMD ["./main"]
```

### JSON
```json
{
  "name": "example-project",
  "version": "1.0.0",
  "description": "A sample project configuration",
  "config": {
    "server": {
      "host": "0.0.0.0",
      "port": 8080,
      "timeout": 30
    },
    "database": {
      "host": "localhost",
      "port": 5432,
      "name": "mydb"
    }
  }
}
```

### SQL
```sql
-- Create users table
CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    role        VARCHAR(50) DEFAULT 'user',
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

-- Create index
CREATE INDEX idx_users_email ON users(email);

-- Insert sample data
INSERT INTO users (name, email, role) VALUES
    ('John Appleseed', 'john@example.com', 'admin'),
    ('Jane Doe', 'jane@example.com', 'user'),
    ('Bob Smith', 'bob@example.com', 'user');

-- Query with join
SELECT u.name, u.email, p.bio
FROM users u
LEFT JOIN profiles p ON u.id = p.user_id
WHERE u.role = 'admin'
ORDER BY u.created_at DESC;
```

---

## Badge

<span class="badge badge-pill">Go</span>
<span class="badge badge-pill">Python</span>
<span class="badge badge-pill">Kotlin</span>
<span class="badge badge-pill">TypeScript</span>
<span class="badge badge-pill">Docker</span>
<span class="badge badge-pill">Kubernetes</span>
<span class="badge badge-pill">PostgreSQL</span>
<span class="badge badge-pill">AWS</span>
<span class="badge badge-pill">Active</span>
<span class="badge badge-pill">Completed</span>
<span class="badge badge-pill">Open Source</span>
<span class="badge badge-pill">Documentation</span>

---

## Divider

Content above the divider.

---

Content below the divider. Use `---` to separate major sections of a page. Avoid overusing dividers — only use when a clear visual break is needed between unrelated sections.