---
layout: page
title: Amanah Laundry
permalink: /projects/mzsamanahlaundry
---

# Amanah Laundry

**Amanah Laundry** is a web-based laundry management system that streamlines the daily operations of a laundry business, from receiving customer orders and tracking each stage of the washing process to accepting online payments and generating transaction reports. Built with Laravel and MySQL, it integrates the Midtrans Snap payment gateway and replaces manual paper-based tracking with a single digital workflow.

<img src="https://placehold.co/860x400?text=Amanah+Laundry+Cover" alt="Amanah Laundry cover" class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack Developer |
| **Type** | Web Application (Laundry Management System) |
| **Stack** | PHP, Laravel, MySQL, Blade, Midtrans Snap |
| **Architecture** | Monolithic MVC with third-party payment integration |
| **Deployment** | Shared Hosting |
| **Completed** | February 2022 |
| **Status** | Delivered and used for daily laundry operations |

---

## Problem & Goals

### Problem
Orders were tracked on paper, which made errors in order management likely and made financial reporting slow. Customers could not easily pay by card, bank transfer, or e-wallet, and staff had no single place to see the status of every order.

### Goals
- Digitize the full order workflow, from intake to pickup.
- Give staff a clear view of each order's progress through every laundry stage.
- Accept cashless payments and update order status automatically after payment.
- Produce revenue and order reports without manual calculation.

---

## My Contributions

- Designed the relational database schema covering users, customers, services, orders, payments, and reports.
- Implemented the order, tracking, pricing, and reporting logic with Laravel.
- Integrated **Midtrans Snap**, including payment token creation and payment callback handling.
- Built the server-rendered interface with Blade templates.
- Implemented role-based access for administrators and cashiers, then deployed the application to shared hosting.

---

## Key Features

- **Order Management** - Create and manage customer orders with item details, weight, and service type (regular, express, dry clean).
- **Laundry Tracking** - Monitor each order through the stages received, washing, drying, ironing, ready for pickup, and completed.
- **Payment Processing** - Pay by credit/debit card, bank transfer, or e-wallet (GoPay, OVO, Dana, ShopeePay) through Midtrans Snap. Payment callbacks update the order status automatically after a successful payment.
- **Transaction Reports** - Generate daily, monthly, and custom-range reports covering revenue, order volume, and payment status.
- **Customer Management** - Maintain a customer database with contact information and order history.
- **Price List Management** - Configure service types with pricing per kilogram or per item.
- **User Authentication** - Role-based access control with separate permissions for Admin and Kasir.

---

## Architecture

The application follows the standard Laravel MVC request flow and delegates payment processing to Midtrans, so sensitive card details never pass through the application.

<pre><code>Browser -&gt; Laravel Routes -&gt; Middleware (auth, role) -&gt; Controller
        -&gt; Eloquent Models -&gt; MySQL
        -&gt; Blade View -&gt; HTML Response

Midtrans -&gt; Payment Callback Route -&gt; Controller -&gt; payments / orders
</code></pre>

### Payment Flow

<pre><code>1. Cashier creates an order and chooses online payment
2. Laravel requests a Snap token from Midtrans and stores it in payments
3. The Snap popup opens and the customer selects a payment method
4. The customer completes the payment
5. Midtrans sends a callback with the transaction result
6. Laravel updates payment_status and the related order automatically
</code></pre>

### Order Lifecycle

| Stage | Meaning |
|---|---|
| `received` | Order accepted and recorded |
| `washing` | Laundry is being washed |
| `drying` | Laundry is being dried |
| `ironing` | Laundry is being ironed |
| `ready` | Ready for customer pickup |
| `completed` | Picked up and closed |
| `cancelled` | Order cancelled |

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Midtrans Snap for online payments | Supports cards, bank transfer, and e-wallets without handling card data directly | Depends on an external service and on reliable callback handling |
| Separate `payments` table with Midtrans fields | Keeps gateway details (Snap token, transaction ID, status) apart from order data and preserves payment history | Extra join when reading an order with its payments |
| `orders` and `order_items` linked to `services` | One order can contain several service types, and `unit_price` keeps the price at the time of the order | More joins when querying |
| `is_active` flag on `services` | Retires a service without breaking historical orders | Inactive services must be filtered in the interface |
| Monolithic MVC with Blade | Simple to build, deploy, and maintain on shared hosting | Less interactive than a single-page application |

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for all business data |
| Blade Templating | Server-side rendered frontend views |
| Midtrans Snap | Payment gateway for cards, bank transfer, and e-wallets |
| Shared Hosting | Deployment environment |

---

## Roles & Access

| Role | Access |
|---|---|
| **Admin** | Full access to orders, payments, reports, customer data, price list, and user management |
| **Kasir** | Operational access to create orders, process payments, update order status, and view reports |

---

## Security

- **Authentication** - Login required for every management page.
- **Authorization** - Two roles (`admin` and `kasir`) control what each user can do.
- **Credentials** - Passwords are stored as hashes, never as plain text.
- **Payment Data** - Card details are entered in the Midtrans popup. The database stores only the Snap token, transaction ID, and payment status.
- **Data Integrity** - Foreign keys and unique constraints (for example on invoice numbers and emails) prevent inconsistent records.

---

## Data Model

Designed with 7 core tables covering users, customers, services, orders, order items, payments, and reporting. All relationships are defined with foreign keys to maintain data integrity.

| Table | Description |
|---|---|
| `users` | Login credentials and role (admin / kasir) |
| `customers` | Customer profiles and contact information |
| `services` | Laundry service types with pricing per kg or per item |
| `orders` | Order header with customer reference, status, and due date |
| `order_items` | Line items per order linked to a service type |
| `payments` | Payment records with Midtrans transaction details and status |
| `reports` | Generated report records with summary data |

<img src="{{ site.baseurl }}/assets/projects/mzsamanahlaundry/database-design.png" alt="Amanah Laundry database design ERD" class="img-fluid rounded" onerror="this.style.display='none'" />

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
  customer_id bigint [ref: &gt; customers.id]
  status enum('received', 'washing', 'drying', 'ironing', 'ready', 'completed', 'cancelled') [default: 'received']
  due_date date [not null]
  total_amount decimal(15,2) [not null]
  paid_amount decimal(15,2) [default: 0]
  notes text
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table order_items {
  id bigint [pk, increment]
  order_id bigint [ref: &gt; orders.id]
  service_id bigint [ref: &gt; services.id]
  quantity decimal(8,2) [not null, note: 'kg or item count']
  unit_price decimal(10,2) [not null]
  subtotal decimal(15,2) [not null]
  created_at timestamp
}

Table payments {
  id bigint [pk, increment]
  order_id bigint [ref: &gt; orders.id]
  snap_token varchar(255) [note: 'Midtrans Snap token for payment popup']
  transaction_id varchar(100) [note: 'Midtrans transaction ID from callback']
  amount decimal(15,2) [not null]
  payment_method enum('credit_card', 'bank_transfer', 'gopay', 'ovo', 'dana', 'shopeepay', 'cash') [not null]
  payment_status enum('pending', 'settlement', 'cancel', 'expire', 'refund') [default: 'pending']
  payment_date datetime
  notes text
  created_by bigint [ref: &gt; users.id]
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
  generated_by bigint [ref: &gt; users.id]
  created_at timestamp
}
</code></pre>

</details>

---

## Results & Impact

- Delivered as a **full-stack solution** covering the complete workflow of a laundry business, from order intake to payment and reporting.
- Replaced manual paper-based tracking with a digital system, reducing errors in order management.
- Made financial reporting significantly faster through automatic daily, monthly, and custom-range reports.