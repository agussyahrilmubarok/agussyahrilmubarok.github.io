---
layout: page
title: Amanah Laundry
permalink: /projects/mzsamanahlaundry
---

# Amanah Laundry

**Amanah Laundry** is a web-based laundry management system built to streamline day-to-day operations of a laundry business — from receiving customer orders to tracking laundry progress, processing payments, and generating transaction reports.

---

## Overview

| | |
|---|---|
| **Type** | Web Application (CMS) |
| **Stack** | PHP, Laravel, MySQL, Midtrans Snap |
| **Deployment** | Shared Hosting |

---

## Features

- **Order Management** — Create and manage customer laundry orders with item details, weight, and service type (regular, express, dry clean).
- **Laundry Tracking** — Monitor the status of each order through stages: received, washing, drying, ironing, ready for pickup, and completed.
- **Payment Processing** — Integrated with **Midtrans Snap** for seamless in-app payments supporting credit/debit cards, bank transfers, and e-wallets (GoPay, OVO, Dana, ShopeePay). Handles payment callbacks and updates order status automatically upon successful payment.
- **Transaction Reports** — Generate daily, monthly, and custom-range reports covering revenue, order volume, and payment status.
- **Customer Management** — Maintain a customer database with order history and contact information.
- **Price List Management** — Configure service types and pricing per kg or per item for different laundry categories.
- **User Authentication** — Role-based access control with separate permissions for Admin and Kasir.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for storing all business data |
| Blade Templating | Server-side rendered frontend views |
| Midtrans Snap | Payment gateway — cards, bank transfer, e-wallets |
| Shared Hosting | Deployment environment |

---

## Roles & Access

| Role | Access |
|---|---|
| **Admin** | Full access — orders, payments, reports, customer data, price list, user management |
| **Kasir** | Operational access — create orders, process payments, update order status, view reports |

---

## Highlights

This project was built as a **full-stack solution** covering the complete workflow of a laundry business. It replaced manual paper-based tracking with a digital system, reducing errors in order management and making financial reporting significantly faster.

---

## Database Design

Designed with 7 core tables covering users, customers, services, orders, order items, payments, and reporting. All relationships are defined with foreign keys to maintain data integrity.

| Table | Description |
|---|---|
| `users` | Login credentials and role (admin / kasir) |
| `customers` | Customer profiles and contact information |
| `services` | Laundry service types with pricing per kg or per item |
| `orders` | Order header with customer reference, status, and due date |
| `order_items` | Line items per order linked to service type |
| `payments` | Payment records with Midtrans transaction details and status |
| `reports` | Generated report records with summary data |

<img src="{{ site.baseurl }}/assets/projects/mzsamanahlaundry/database-design.png" alt="Amanah Laundry Database Design" onerror="this.style.display='none'" />

> View full ERD on [dbdiagram.io](https://dbdiagram.io) — paste the DBML below to render it.

<details>
<summary>Show DBML schema</summary>

```dbml
Table users {
  id bigint [pk, increment]
  name varchar(100) [not null]
  email varchar(100) [unique, not null]
  password varchar(255) [not null]
  role enum('admin', 'kasir') [not null, default: 'kasir']
  created_at timestamp
  updated_at timestamp
}

Table customers {
  id bigint [pk, increment]
  name varchar(100) [not null]
  phone varchar(20)
  address text
  created_at timestamp
  updated_at timestamp
}

Table services {
  id bigint [pk, increment]
  name varchar(100) [not null, note: 'e.g. Regular Wash, Express, Dry Clean']
  unit enum('kg', 'item') [not null, default: 'kg']
  price decimal(10,2) [not null]
  duration_days int [not null, default: 3, note: 'Estimated days to complete']
  is_active boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table orders {
  id bigint [pk, increment]
  invoice_number varchar(50) [unique, not null, note: 'e.g. INV-20220501-001']
  customer_id bigint [ref: > customers.id]
  status enum('received', 'washing', 'drying', 'ironing', 'ready', 'completed', 'cancelled') [default: 'received']
  due_date date [not null]
  total_amount decimal(15,2) [not null]
  paid_amount decimal(15,2) [default: 0]
  notes text
  created_by bigint [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table order_items {
  id bigint [pk, increment]
  order_id bigint [ref: > orders.id]
  service_id bigint [ref: > services.id]
  quantity decimal(8,2) [not null, note: 'kg or item count']
  unit_price decimal(10,2) [not null]
  subtotal decimal(15,2) [not null]
  created_at timestamp
}

Table payments {
  id bigint [pk, increment]
  order_id bigint [ref: > orders.id]
  snap_token varchar(255) [note: 'Midtrans Snap token for payment popup']
  transaction_id varchar(100) [note: 'Midtrans transaction ID from callback']
  amount decimal(15,2) [not null]
  payment_method enum('credit_card', 'bank_transfer', 'gopay', 'ovo', 'dana', 'shopeepay', 'cash') [not null]
  payment_status enum('pending', 'settlement', 'cancel', 'expire', 'refund') [default: 'pending']
  payment_date datetime
  notes text
  created_by bigint [ref: > users.id]
  created_at timestamp
}

Table reports {
  id bigint [pk, increment]
  title varchar(150) [not null]
  type enum('daily', 'monthly', 'yearly', 'custom') [not null]
  start_date date [not null]
  end_date date [not null]
  total_orders int
  total_revenue decimal(15,2)
  generated_by bigint [ref: > users.id]
  created_at timestamp
}
```

</details>