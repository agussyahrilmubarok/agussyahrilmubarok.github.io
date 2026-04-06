---
layout: page
title: FOS Motor
permalink: /projects/fosmotor
---

# FOS Motor

**FOS Motor** is a web-based Content Management System (CMS) built to help a motorcycle dealership manage their day-to-day business operations — from tracking inventory to recording sales and generating reports.

---

## Overview

| | |
|---|---|
| **Type** | Web Application (CMS) |
| **Stack** | PHP, Laravel, MySQL |
| **Deployment** | Shared Hosting |
| **Status** | Completed — January 2021 |

---

## Features

- **Stock Management** — Add, update, and monitor motorcycle inventory in real time, including unit details and availability status.
- **Sales Transactions** — Record and manage sales transactions, track buyer information, and maintain a complete transaction history.
- **Reports** — Generate sales and stock reports to help the business owner monitor performance and make informed decisions.
- **User Authentication** — Secure login system to ensure only authorized users can access and manage the system.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for storing all business data |
| Blade Templating | Server-side rendered frontend views |
| Shared Hosting | Deployment environment |

---

## Highlights

This project was built as a **full-stack solution** from scratch — covering database design, backend logic, and frontend UI. It was deployed on a live hosting environment and used by the dealership to replace their manual record-keeping process.

## Database Design

Designed with 5 core tables covering users, inventory, transactions, and reporting. All relationships are defined with foreign keys to maintain data integrity.

<img src="{{ site.baseurl }}/assets/projects/fosmotor/database-design.png" alt="" onerror="this.style.display='none'" />


> View full ERD on [dbdiagram.io](https://dbdiagram.io) — paste the DBML below to render it.

<details>
<summary>Show DBML schema</summary>

```bash
Table users {
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
  created_by bigint [ref: > users.id]
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
  created_by bigint [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table transaction_items {
  id bigint [pk, increment]
  transaction_id bigint [ref: > transactions.id]
  motor_stock_id bigint [ref: > motor_stocks.id]
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
  generated_by bigint [ref: > users.id]
  created_at timestamp
}
```

</details>