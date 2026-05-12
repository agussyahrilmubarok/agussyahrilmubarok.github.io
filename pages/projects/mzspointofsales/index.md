---
layout: page
title: MZS Point of Sales
permalink: /projects/mzspointofsales
---

# MZS Point of Sales

**MZS Point of Sales** is a multi-tenant SaaS POS application built with Laravel, where businesses can subscribe and get their own isolated POS system accessible via a dedicated subdomain. Designed to handle the full retail workflow — from product and inventory management to cashier transactions, payment processing, and sales reporting.

---

## Overview

| | |
|---|---|
| **Type** | SaaS Web Application (Multi-Tenant POS) |
| **Stack** | PHP, Laravel, MySQL, Midtrans Snap |
| **Architecture** | Multi-tenant, subdomain-based isolation |
| **Deployment** | Shared Hosting |

---

## Features

### Platform (Superadmin)
- **Tenant Management** — Register and manage client businesses, monitor subscription status, and control platform-wide settings.
- **Subscription Management** — Handle B2B subscription plans (monthly/yearly) with trial period support and plan activation/deactivation.
- **Platform Analytics** — Overview of total active tenants, revenue, and subscription metrics.

### POS Application (Per Tenant)
- **Cashier Transactions** — Fast and intuitive cashier interface for processing sales with support for cash, Midtrans Snap, and BCA card payments.
- **Product Management** — Manage product catalog with categories, pricing, SKU, and product images.
- **Inventory Management** — Track stock in and out with low-stock notifications to prevent stockouts.
- **Customer Management** — Maintain customer profiles with purchase history.
- **Sales Reports** — Comprehensive reporting covering daily and monthly sales, best-selling products, sales per cashier, stock movement, and revenue summaries.
- **User Authentication** — Role-based access control with distinct permissions per role within each tenant.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, multi-tenant logic, routing |
| MySQL | Relational database with shared schema, tenant-isolated data |
| Blade Templating | Server-side rendered frontend views |
| Midtrans Snap | Payment gateway for cashier — cards, bank transfer, e-wallets |
| BCA Card | Direct card payment integration at cashier |
| Subdomain Routing | Tenant isolation via dedicated subdomains |
| Shared Hosting | Deployment environment |

---

## Multi-Tenant Architecture

Each client gets their own subdomain (e.g. `tokoa.mzs.app`, `tokob.mzs.app`) that maps to their isolated data within a shared database. Tenant context is resolved on every request via subdomain detection middleware, ensuring complete data separation between clients.

| Layer | Approach |
|---|---|
| **Routing** | Subdomain-based tenant resolution |
| **Data Isolation** | Shared database, tenant-scoped queries |
| **Authentication** | Per-tenant user sessions |
| **Subscription** | B2B billing, monthly / yearly plans with trial |

---

## Roles & Access

| Role | Scope | Access |
|---|---|---|
| **Superadmin** | Platform | Tenant management, subscription control, platform analytics |
| **Admin** | Per Tenant | Full access — products, inventory, reports, user management, settings |
| **Kasir** | Per Tenant | Cashier transactions, view products, process payments |

---

## Highlights

This project goes beyond a typical POS system — it is a fully functional **SaaS platform** where multiple businesses can independently subscribe and operate their own POS without interfering with each other's data. Key engineering challenges included implementing subdomain-based multi-tenancy in Laravel, managing tenant context across the request lifecycle, and integrating multiple payment methods for both cashier transactions and B2B subscriptions.

---

## Database Design

Designed with two layers — a **platform layer** managing tenants and subscriptions, and a **tenant layer** managing POS operations per client. All relationships are enforced with foreign keys and tenant scoping to ensure data integrity and isolation.

| Table | Layer | Description |
|---|---|---|
| `tenants` | Platform | Registered client businesses with subdomain and status |
| `subscription_plans` | Platform | Available plans with pricing and duration |
| `subscriptions` | Platform | Active subscriptions per tenant with billing cycle |
| `users` | Tenant | Per-tenant users with roles (admin / kasir) |
| `products` | Tenant | Product catalog with pricing, SKU, and category |
| `inventory_logs` | Tenant | Stock in/out records with timestamps |
| `customers` | Tenant | Customer profiles and purchase history |
| `transactions` | Tenant | Cashier transaction header with payment method and status |
| `transaction_items` | Tenant | Line items per transaction linked to products |
| `payments` | Tenant | Payment records with Midtrans or BCA card details |
| `reports` | Tenant | Generated report summaries by date range and type |

<img src="{{ site.baseurl }}/assets/projects/mzspointofsales/database-design.png" alt="MZS Point of Sales Database Design" onerror="this.style.display='none'" />

> View full ERD on [dbdiagram.io](https://dbdiagram.io) — paste the DBML below to render it.

<details>
<summary>Show DBML schema</summary>

```dbml
Table tenants {
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
  tenant_id bigint [ref: > tenants.id]
  plan_id bigint [ref: > subscription_plans.id]
  status enum('trial', 'active', 'cancelled', 'expired') [default: 'trial']
  starts_at date [not null]
  ends_at date [not null]
  created_at timestamp
  updated_at timestamp
}

// ── TENANT LAYER ────────────────────────────────────────────

Table users {
  id bigint [pk, increment]
  tenant_id bigint [ref: > tenants.id]
  name varchar(100) [not null]
  email varchar(100) [not null]
  password varchar(255) [not null]
  role enum('admin', 'kasir') [not null, default: 'kasir']
  created_at timestamp
  updated_at timestamp
}

Table products {
  id bigint [pk, increment]
  tenant_id bigint [ref: > tenants.id]
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
  tenant_id bigint [ref: > tenants.id]
  product_id bigint [ref: > products.id]
  type enum('in', 'out', 'adjustment') [not null]
  quantity int [not null]
  notes text
  created_by bigint [ref: > users.id]
  created_at timestamp
}

Table customers {
  id bigint [pk, increment]
  tenant_id bigint [ref: > tenants.id]
  name varchar(100) [not null]
  phone varchar(20)
  email varchar(100)
  address text
  created_at timestamp
  updated_at timestamp
}

Table transactions {
  id bigint [pk, increment]
  tenant_id bigint [ref: > tenants.id]
  invoice_number varchar(50) [unique, not null]
  customer_id bigint [ref: > customers.id, null]
  total_amount decimal(15,2) [not null]
  discount decimal(15,2) [default: 0]
  grand_total decimal(15,2) [not null]
  payment_method enum('cash', 'midtrans', 'bca_card') [not null]
  payment_status enum('pending', 'paid', 'cancelled', 'refunded') [default: 'pending']
  notes text
  created_by bigint [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table transaction_items {
  id bigint [pk, increment]
  transaction_id bigint [ref: > transactions.id]
  product_id bigint [ref: > products.id]
  quantity int [not null]
  unit_price decimal(15,2) [not null]
  subtotal decimal(15,2) [not null]
  created_at timestamp
}

Table payments {
  id bigint [pk, increment]
  transaction_id bigint [ref: > transactions.id]
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
  tenant_id bigint [ref: > tenants.id]
  title varchar(150) [not null]
  type enum('daily_sales', 'monthly_sales', 'product_performance', 'cashier_performance', 'stock_movement', 'revenue_summary') [not null]
  start_date date [not null]
  end_date date [not null]
  total_transactions int
  total_revenue decimal(15,2)
  generated_by bigint [ref: > users.id]
  created_at timestamp
}
```

</details>