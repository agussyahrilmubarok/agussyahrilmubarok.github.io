---
layout: page
title: MZS Point of Sales
permalink: /projects/mzspointofsales
---

# MZS Point of Sales

**MZS Point of Sales** is a multi-tenant SaaS POS application built with Laravel. Businesses subscribe and receive their own isolated POS system on a dedicated subdomain, covering the full retail workflow: product and inventory management, cashier transactions, payment processing, and sales reporting. Beyond a typical POS, it is a complete **SaaS platform** where many businesses operate independently on one codebase and one database without interfering with each other's data.

<img src="https://placehold.co/860x400?text=MZS+Point+of+Sales+Cover" alt="MZS Point of Sales cover" class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack Developer |
| **Type** | SaaS Web Application (Multi-Tenant POS) |
| **Stack** | PHP, Laravel, MySQL, Blade, Midtrans Snap |
| **Architecture** | Multi-tenant, subdomain-based isolation, shared database with tenant-scoped queries |
| **Deployment** | Shared Hosting |
| **Completed** | July 2022 |
| **Status** | Delivered as a subscription-based platform |

---

## Problem & Goals

### Problem
Small and medium retail businesses need a POS system, but running a separate installation for each client is costly to deploy and maintain. A shared platform is only viable if every client's data stays strictly isolated and billing is handled per subscription.

### Goals
- Let each business subscribe and receive its own POS on a dedicated subdomain.
- Keep every tenant's data fully separated within a shared database.
- Cover the retail workflow: catalog, stock, cashier sales, customers, and reports.
- Support several payment methods at the cashier and subscription billing for the platform.
- Give the platform owner tools to manage tenants, plans, and revenue.

---

## My Contributions

- Designed a two-layer relational schema: a platform layer (tenants, plans, subscriptions) and a tenant layer (POS operations).
- Implemented subdomain-based multi-tenancy in Laravel, including tenant resolution through middleware.
- Built the cashier flow with cash, **Midtrans Snap**, and BCA card payments.
- Implemented inventory tracking with stock movements and low-stock notifications.
- Implemented the six report types and role-based access at platform and tenant level.
- Deployed the application to shared hosting.

---

## Key Features

### Platform (Superadmin)
- **Tenant Management** - Register and manage client businesses, monitor subscription status, and control platform-wide settings.
- **Subscription Management** - Handle monthly and yearly B2B plans with trial period support and plan activation or deactivation.
- **Platform Analytics** - Overview of active tenants, revenue, and subscription metrics.

### POS Application (Per Tenant)
- **Cashier Transactions** - A fast cashier interface for sales paid by cash, Midtrans Snap, or BCA card.
- **Product Management** - Manage the catalog with categories, pricing, SKU, and product images.
- **Inventory Management** - Track stock in, out, and adjustments, with low-stock notifications to prevent stockouts.
- **Customer Management** - Maintain customer profiles with purchase history.
- **Sales Reports** - Daily and monthly sales, product performance, cashier performance, stock movement, and revenue summaries.
- **User Authentication** - Role-based access control with distinct permissions per role within each tenant.

---

## Architecture

Each client gets a dedicated subdomain (for example `tokoa.mzs.app` or `tokob.mzs.app`) that maps to its isolated data in a shared database. Tenant context is resolved on every request by subdomain detection middleware, which keeps client data completely separated.

<pre><code>Browser (tokoa.mzs.app) -&gt; Laravel Routes
        -&gt; Tenant Middleware (resolve subdomain to tenant)
        -&gt; Auth Middleware (per-tenant session and role)
        -&gt; Controller -&gt; Eloquent Models (tenant-scoped queries)
        -&gt; MySQL (shared schema) -&gt; Blade View -&gt; HTML Response
</code></pre>

| Layer | Approach |
|---|---|
| **Routing** | Subdomain-based tenant resolution |
| **Data Isolation** | Shared database with tenant-scoped queries |
| **Authentication** | Per-tenant user sessions |
| **Subscription** | B2B billing with monthly and yearly plans and a trial period |

### Tenant Lifecycle

| Status | Meaning |
|---|---|
| `trial` | New tenant in its trial period, ending at `trial_ends_at` |
| `active` | Tenant with a paid, active subscription |
| `suspended` | Tenant temporarily blocked from using the platform |
| `expired` | Trial or subscription ended without renewal |

### Payment Methods at the Cashier

| Method | Handling |
|---|---|
| **Cash** | Recorded directly on the transaction |
| **Midtrans Snap** | Snap token is created for the payment popup, and the Midtrans callback updates the payment status |
| **BCA Card** | Card payment recorded with its approval code |

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Shared database with a `tenant_id` column on tenant tables | Simple to deploy and maintain on shared hosting, and cheap to run for many tenants | Isolation depends on every query being tenant-scoped |
| Subdomain-based tenant resolution in middleware | The tenant is identified once per request, before any controller logic runs | Requires wildcard DNS and hosting that supports subdomains |
| Separate platform and tenant layers | Platform data (plans, subscriptions) stays apart from POS data | Two sets of concerns to keep consistent |
| Plan limits stored on `subscription_plans` (`max_users`, `max_products`) | Subscription tiers can be enforced and changed without code changes | Limits must be checked wherever users or products are created |
| `inventory_logs` with `in`, `out`, and `adjustment` types | Every stock change leaves an audit trail | Stock and log entries must be updated together |
| `unit_price` and `subtotal` stored on `transaction_items` | Keeps the price at the time of sale even if the catalog price changes | Some duplicated data |
| Separate `payments` table for gateway details | Keeps Midtrans and BCA fields apart from the sale itself | Extra join when reading a transaction with its payments |
| Monolithic MVC with Blade | Simple to build, deploy, and maintain on shared hosting | Less interactive than a single-page application |

---

## Engineering Challenges

| Challenge | Approach |
|---|---|
| Subdomain-based multi-tenancy in Laravel | Resolve the tenant from the subdomain on every request through middleware |
| Managing tenant context across the request lifecycle | Scope tenant queries by `tenant_id` and keep user sessions per tenant |
| Multiple payment methods for cashier and subscription billing | Store gateway details in `payments`, with separate fields for Midtrans and BCA card data |

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, multi-tenant logic, routing |
| MySQL | Relational database with a shared schema and tenant-isolated data |
| Blade Templating | Server-side rendered frontend views |
| Midtrans Snap | Payment gateway for the cashier: cards, bank transfer, e-wallets |
| BCA Card | Direct card payment integration at the cashier |
| Subdomain Routing | Tenant isolation through dedicated subdomains |
| Shared Hosting | Deployment environment |

---

## Roles & Access

| Role | Scope | Access |
|---|---|---|
| **Superadmin** | Platform | Tenant management, subscription control, platform analytics |
| **Admin** | Per Tenant | Full access to products, inventory, reports, user management, and settings |
| **Kasir** | Per Tenant | Cashier transactions, viewing products, and processing payments |

---

## Security & Tenant Isolation

- **Tenant Resolution** - The tenant is identified from the subdomain on every request, before the controller runs.
- **Data Isolation** - Tenant tables carry a `tenant_id`, and queries are scoped to the current tenant.
- **Authentication** - Per-tenant user sessions, with roles controlling what each user can do.
- **Credentials** - Passwords are stored as hashes, never as plain text.
- **Payment Data** - The database stores the Snap token, gateway transaction ID, BCA approval code, and status, not card details.
- **Data Integrity** - Foreign keys and unique constraints (such as invoice numbers and subdomains) prevent inconsistent records.

---

## Data Model

Designed with two layers: a **platform layer** managing tenants and subscriptions, and a **tenant layer** managing POS operations per client. All relationships are enforced with foreign keys and tenant scoping to protect data integrity and isolation.

| Table | Layer | Description |
|---|---|---|
| `tenants` | Platform | Registered client businesses with subdomain and status |
| `subscription_plans` | Platform | Available plans with pricing, billing cycle, and limits |
| `subscriptions` | Platform | Subscriptions per tenant with status and dates |
| `users` | Tenant | Per-tenant users with roles (admin / kasir) |
| `products` | Tenant | Product catalog with pricing, SKU, category, and stock |
| `inventory_logs` | Tenant | Stock in, out, and adjustment records |
| `customers` | Tenant | Customer profiles and contact information |
| `transactions` | Tenant | Sale header with totals, discount, payment method, and status |
| `transaction_items` | Tenant | Line items per transaction linked to products |
| `payments` | Tenant | Payment records with Midtrans or BCA card details |
| `reports` | Tenant | Generated report summaries by date range and type |

<img src="{{ site.baseurl }}/assets/projects/mzspointofsales/database-design.png" alt="MZS Point of Sales database design ERD" class="img-fluid rounded" onerror="this.style.display='none'" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>Table tenants {
  id bigint [pk, increment]
  name varchar(100) [not null]
  subdomain varchar(50) [unique, not null]
  email varchar(100) [unique, not null]
  status enum('trial', 'active', 'suspended', 'expired') [default: 'trial']
  trial_ends_at timestamp
  created_at timestamp
  updated_at timestamp
}

Table subscription_plans {
  id bigint [pk, increment]
  name varchar(100) [not null, note: 'e.g. Starter, Business, Enterprise']
  price decimal(15,2) [not null]
  billing_cycle enum('monthly', 'yearly') [not null]
  max_users int [not null]
  max_products int [not null]
  features text [note: 'JSON list of included features']
  is_active boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table subscriptions {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  plan_id bigint [ref: &gt; subscription_plans.id]
  status enum('trial', 'active', 'cancelled', 'expired') [default: 'trial']
  starts_at date [not null]
  ends_at date [not null]
  created_at timestamp
  updated_at timestamp
}

// ── TENANT LAYER ────────────────────────────────────────────

Table users {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  name varchar(100) [not null]
  email varchar(100) [not null]
  password varchar(255) [not null]
  role enum('admin', 'kasir') [not null, default: 'kasir']
  created_at timestamp
  updated_at timestamp
}

Table products {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  name varchar(150) [not null]
  sku varchar(50) [unique]
  category varchar(100)
  price decimal(15,2) [not null]
  stock int [not null, default: 0]
  low_stock_threshold int [default: 5]
  image_url varchar(255)
  is_active boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table inventory_logs {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  product_id bigint [ref: &gt; products.id]
  type enum('in', 'out', 'adjustment') [not null]
  quantity int [not null]
  notes text
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
}

Table customers {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  name varchar(100) [not null]
  phone varchar(20)
  email varchar(100)
  address text
  created_at timestamp
  updated_at timestamp
}

Table transactions {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  invoice_number varchar(50) [unique, not null]
  customer_id bigint [ref: &gt; customers.id, null]
  total_amount decimal(15,2) [not null]
  discount decimal(15,2) [default: 0]
  grand_total decimal(15,2) [not null]
  payment_method enum('cash', 'midtrans', 'bca_card') [not null]
  payment_status enum('pending', 'paid', 'cancelled', 'refunded') [default: 'pending']
  notes text
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table transaction_items {
  id bigint [pk, increment]
  transaction_id bigint [ref: &gt; transactions.id]
  product_id bigint [ref: &gt; products.id]
  quantity int [not null]
  unit_price decimal(15,2) [not null]
  subtotal decimal(15,2) [not null]
  created_at timestamp
}

Table payments {
  id bigint [pk, increment]
  transaction_id bigint [ref: &gt; transactions.id]
  snap_token varchar(255) [note: 'Midtrans Snap token']
  transaction_id_midtrans varchar(100) [note: 'Midtrans transaction ID from callback']
  bca_approval_code varchar(50) [note: 'BCA card approval code']
  amount decimal(15,2) [not null]
  payment_status enum('pending', 'settlement', 'cancel', 'expire', 'refund') [default: 'pending']
  payment_date datetime
  created_at timestamp
}

Table reports {
  id bigint [pk, increment]
  tenant_id bigint [ref: &gt; tenants.id]
  title varchar(150) [not null]
  type enum('daily_sales', 'monthly_sales', 'product_performance', 'cashier_performance', 'stock_movement', 'revenue_summary') [not null]
  start_date date [not null]
  end_date date [not null]
  total_transactions int
  total_revenue decimal(15,2)
  generated_by bigint [ref: &gt; users.id]
  created_at timestamp
}
</code></pre>

</details>

---

## Results & Impact

- Delivered a working **multi-tenant SaaS platform** where several businesses subscribe and run their own POS independently.
- Implemented subdomain-based tenant isolation in Laravel, with tenant context managed across the request lifecycle.
- Integrated multiple payment methods (cash, Midtrans Snap, BCA card) for cashier transactions.
- Provided subscription management with trial periods, monthly and yearly plans, and plan limits.