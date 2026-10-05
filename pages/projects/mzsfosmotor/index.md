---
layout: page
title: FOS Motor
permalink: /projects/mzsfosmotor
---

# FOS Motor

**FOS Motor** is a web-based Content Management System (CMS) that helps a motorcycle dealership run its daily operations, from tracking inventory to recording sales and generating reports. Built with Laravel and MySQL, it replaced the dealership's manual record-keeping with a single, secure, and searchable system.

<img src="https://placehold.co/860x400?text=FOS+Motor+Cover" alt="FOS Motor cover" class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack Developer |
| **Type** | Web Application (CMS) |
| **Stack** | PHP, Laravel, MySQL, Blade |
| **Architecture** | Monolithic MVC |
| **Deployment** | Shared Hosting |
| **Completed** | January 2022 |
| **Status** | Delivered and used by the dealership |

---

## Problem & Goals

### Problem
The dealership tracked stock, sales, and reports manually. Records were scattered, hard to search, and slow to consolidate whenever the owner needed a summary of performance.

### Goals
- Centralize motorcycle inventory with real-time availability status.
- Record every sale with buyer details and a unique invoice number.
- Generate sales and stock reports on demand.
- Restrict access so only authorized staff can manage data.

---

## My Contributions

- Designed the relational database schema, including tables, relationships, and constraints.
- Implemented the backend logic for stock, transactions, and reporting with Laravel.
- Built the server-rendered user interface with Blade templates.
- Implemented authentication and role-based access for administrators and cashiers.
- Deployed the application to a live shared hosting environment.

---

## Key Features

- **Stock Management** - Add, update, and monitor motorcycle inventory in real time, including unit details (brand, model, year, color, price) and availability status (available, reserved, sold).
- **Sales Transactions** - Record sales with buyer information, payment method, and payment status, and keep a complete transaction history with unique invoice numbers.
- **Reports** - Generate daily, monthly, yearly, or custom-range reports on sales and stock to support business decisions.
- **User Authentication** - Secure login so only authorized users can access and manage the system.

---

## Architecture

The application follows the standard Laravel MVC request flow, which keeps the codebase simple to maintain and fits the shared hosting environment.

<pre><code>Browser -&gt; Laravel Routes -&gt; Middleware (auth, role) -&gt; Controller
        -&gt; Eloquent Models -&gt; MySQL
        -&gt; Blade View -&gt; HTML Response
</code></pre>

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Monolithic MVC with server-side rendering (Blade) | Simple to build, deploy, and maintain on shared hosting | Less interactive than a single-page application |
| Separate `transactions` and `transaction_items` tables | Supports several units in one invoice and keeps the unit price at the time of sale | More joins when querying |
| Store report summaries in a `reports` table | Quick access to previously generated reports | Summary data can become stale if transactions change |
| Foreign keys on all relationships | Preserves data integrity across users, stock, and sales | Stricter rules when deleting related records |

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for all business data |
| Blade Templating | Server-side rendered frontend views |
| Shared Hosting | Deployment environment |

---

## Roles & Access

| Role | Access |
|---|---|
| **Admin** | Full access to stock, transactions, reports, and user management |
| **Kasir** | Records sales transactions and views available stock |

---

## Security

- **Authentication** - Login required for every management page.
- **Authorization** - Two roles (`admin` and `kasir`) control what each user can do.
- **Credentials** - Passwords are stored as hashes, never as plain text.
- **Data Integrity** - Foreign keys and unique constraints (for example on invoice numbers and emails) prevent inconsistent records.

---

## Data Model

Designed with 5 core tables covering users, inventory, transactions, and reporting. All relationships are defined with foreign keys to maintain data integrity.

| Table | Description |
|---|---|
| `users` | Staff accounts, credentials, and roles |
| `motor_stocks` | Motorcycle units with brand, model, year, price, stock, and status |
| `transactions` | Sales header with invoice number, customer, payment method, and status |
| `transaction_items` | Line items linking each transaction to the motorcycles sold |
| `reports` | Generated report summaries by type and date range |

<img src="{{ site.baseurl }}/assets/projects/mzsfosmotor/database-design.png" alt="FOS Motor database design ERD" class="img-fluid rounded" onerror="this.style.display='none'" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>Table users {
  id bigint [pk, increment]
  name varchar(100) [not null]
  email varchar(100) [unique, not null]
  password varchar(255) [not null]
  role enum('admin', 'kasir') [not null, default: 'kasir']
  created_at timestamp
  updated_at timestamp
}

Table motor_stocks {
  id bigint [pk, increment]
  brand varchar(100) [not null, note: 'e.g. Honda, Yamaha']
  model varchar(100) [not null, note: 'e.g. Beat, NMAX']
  year int [not null]
  color varchar(50)
  price decimal(15,2) [not null]
  stock int [not null, default: 0]
  status enum('available', 'sold', 'reserved') [default: 'available']
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table transactions {
  id bigint [pk, increment]
  invoice_number varchar(50) [unique, not null, note: 'e.g. INV-20210101-001']
  customer_name varchar(100) [not null]
  customer_phone varchar(20)
  customer_address text
  total_amount decimal(15,2) [not null]
  payment_method enum('cash', 'transfer', 'credit') [not null]
  payment_status enum('paid', 'pending', 'cancelled') [default: 'pending']
  notes text
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table transaction_items {
  id bigint [pk, increment]
  transaction_id bigint [ref: &gt; transactions.id]
  motor_stock_id bigint [ref: &gt; motor_stocks.id]
  quantity int [not null, default: 1]
  unit_price decimal(15,2) [not null]
  subtotal decimal(15,2) [not null]
  created_at timestamp
}

Table reports {
  id bigint [pk, increment]
  title varchar(150) [not null]
  type enum('daily', 'monthly', 'yearly', 'custom') [not null]
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

- Delivered as a **full-stack solution built from scratch**, covering database design, backend logic, and frontend UI.
- Deployed on a live hosting environment and used by the dealership to replace its manual record-keeping process.