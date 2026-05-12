---
layout: page
title: MZS TOEFL Course CBT
permalink: /projects/mzstoeflcbt
---

# MZS TOEFL Course CBT

**MZS TOEFL Course CBT** is a Computer-Based Test (CBT) platform built for TOEFL courses, enabling students to register, purchase test access, and take scheduled TOEFL examinations online. The system covers the full test lifecycle — from question management and exam scheduling to automated scoring, manual review, and detailed result reporting.

---

## Overview

| | |
|---|---|
| **Type** | Web Application (CBT Platform) |
| **Stack** | PHP, Laravel, MySQL, Xendit |
| **Deployment** | VPS |

---

## Features

### Platform (Superadmin)
- **User Management** — Manage all users across roles: admin, trainer, and student.
- **Platform Settings** — Configure global platform settings, scoring rules, and test parameters.
- **Platform Analytics** — Overview of registered students, active exams, revenue, and test completion rates.

### Course Management (Admin & Trainer)
- **Question Bank Management** — Create, edit, and organize questions across all TOEFL sections: Listening Comprehension, Structure & Written Expression, and Reading Comprehension.
- **Bulk Question Import** — Import questions in bulk from Excel or Word files to speed up question bank setup.
- **Exam Scheduling** — Create exam periods with defined start and end dates, allowing students to choose their preferred test slot within the period.
- **Result Review** — Manually review and override scores for open-ended or flagged responses alongside the automated scoring system.
- **Student Progress Tracking** — Monitor individual student performance, test history, and score trends.

### Student
- **Course Registration** — Register and purchase test access via one-time payment through Xendit.
- **Exam Booking** — Select a preferred test schedule within available exam periods.
- **CBT Interface** — Take TOEFL exams with a built-in timer system, section-by-section navigation, and auto-submit on timeout.
- **Score & Results** — View detailed results immediately after grading, including total score and breakdown per section (Listening, Structure, Reading).
- **Result History** — Access past exam results and score progression over time.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for questions, exams, and results |
| Blade Templating | Server-side rendered frontend views |
| Xendit | Payment gateway for one-time student registration payment |
| VPS | Deployment environment |

---

## Roles & Access

| Role | Access |
|---|---|
| **Superadmin** | Full platform access — users, settings, analytics, all data |
| **Admin** | Course management — question bank, exam scheduling, student results, reports |
| **Trainer** | Question management, result review, student progress monitoring |
| **Student** | Registration, exam booking, CBT interface, personal results |

---

## Exam Flow

1. Student registers and completes one-time payment via Xendit
2. Student selects an available exam slot within the scheduled period
3. On exam day, student enters the CBT interface — timer starts automatically
4. System auto-submits when time runs out
5. Objective questions are scored automatically; flagged items go to trainer review
6. Final score is published with section breakdown (Listening / Structure / Reading)

---

## Highlights

This project required careful engineering around **exam integrity and timing** — ensuring the timer is reliable, auto-submission works correctly on timeout, and students cannot re-enter a completed exam. The dual scoring system (automated + manual review) adds flexibility for complex question types, while Xendit integration handles one-time payments cleanly with webhook-based payment confirmation.

---

## Database Design

Designed with 12 tables covering platform users, question bank, exam scheduling, student registrations, exam sessions, answers, scoring, and payments. All relationships are enforced with foreign keys.

| Table | Description |
|---|---|
| `users` | All platform users with role (superadmin / admin / trainer / student) |
| `courses` | Available TOEFL courses with pricing and description |
| `registrations` | Student course registrations with payment status |
| `payments` | Xendit payment records per registration |
| `question_bank` | Questions categorized by section type and difficulty |
| `question_options` | Answer options per question |
| `exam_periods` | Scheduled exam periods with start and end dates |
| `exam_slots` | Available time slots within each exam period |
| `exam_sessions` | Student exam sessions linked to a slot with timer and status |
| `student_answers` | Student answers per question per session |
| `scores` | Final scores per session with section breakdown |
| `score_reviews` | Manual review records by trainer for flagged answers |

<img src="{{ site.baseurl }}/assets/projects/mzstoeflcbt/database-design.png" alt="MZS TOEFL CBT Database Design" onerror="this.style.display='none'" />

> View full ERD on [dbdiagram.io](https://dbdiagram.io) — paste the DBML below to render it.

<details>
<summary>Show DBML schema</summary>

```dbml
// MZS TOEFL Course CBT - Database Schema
// Paste this into https://dbdiagram.io to render the ERD

Table users {
  id bigint [pk, increment]
  name varchar(100) [not null]
  email varchar(100) [unique, not null]
  password varchar(255) [not null]
  role enum('superadmin', 'admin', 'trainer', 'student') [not null]
  created_at timestamp
  updated_at timestamp
}

Table courses {
  id bigint [pk, increment]
  name varchar(150) [not null]
  description text
  price decimal(15,2) [not null]
  is_active boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table registrations {
  id bigint [pk, increment]
  student_id bigint [ref: > users.id]
  course_id bigint [ref: > courses.id]
  payment_status enum('pending', 'paid', 'failed', 'expired') [default: 'pending']
  registered_at timestamp
  created_at timestamp
  updated_at timestamp
}

Table payments {
  id bigint [pk, increment]
  registration_id bigint [ref: > registrations.id]
  xendit_invoice_id varchar(100) [unique, note: 'Xendit invoice ID']
  xendit_payment_method varchar(50) [note: 'e.g. BCA, OVO, DANA, credit_card']
  amount decimal(15,2) [not null]
  status enum('pending', 'paid', 'failed', 'expired') [default: 'pending']
  paid_at datetime
  created_at timestamp
}

Table question_bank {
  id bigint [pk, increment]
  course_id bigint [ref: > courses.id]
  section enum('listening', 'structure', 'reading') [not null]
  question_text text [not null]
  audio_url varchar(255) [note: 'For listening section questions']
  passage_text text [note: 'For reading section questions']
  correct_option_id bigint [note: 'FK set after options are created']
  scoring_type enum('auto', 'manual') [default: 'auto']
  difficulty enum('easy', 'medium', 'hard') [default: 'medium']
  created_by bigint [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table question_options {
  id bigint [pk, increment]
  question_id bigint [ref: > question_bank.id]
  option_label varchar(5) [not null, note: 'A, B, C, D']
  option_text text [not null]
  created_at timestamp
}

Table exam_periods {
  id bigint [pk, increment]
  course_id bigint [ref: > courses.id]
  name varchar(150) [not null, note: 'e.g. TOEFL Batch October 2022']
  start_date date [not null]
  end_date date [not null]
  is_active boolean [default: true]
  created_by bigint [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table exam_slots {
  id bigint [pk, increment]
  period_id bigint [ref: > exam_periods.id]
  slot_datetime datetime [not null]
  duration_minutes int [not null, default: 115]
  max_participants int [not null]
  created_at timestamp
}

Table exam_sessions {
  id bigint [pk, increment]
  student_id bigint [ref: > users.id]
  slot_id bigint [ref: > exam_slots.id]
  status enum('booked', 'in_progress', 'completed', 'cancelled') [default: 'booked']
  started_at datetime
  submitted_at datetime
  auto_submitted boolean [default: false, note: 'True if submitted by timer']
  created_at timestamp
  updated_at timestamp
}

Table student_answers {
  id bigint [pk, increment]
  session_id bigint [ref: > exam_sessions.id]
  question_id bigint [ref: > question_bank.id]
  selected_option_id bigint [ref: > question_options.id, null]
  is_correct boolean
  created_at timestamp
}

Table scores {
  id bigint [pk, increment]
  session_id bigint [ref: > exam_sessions.id, unique]
  listening_score int
  structure_score int
  reading_score int
  total_score int
  status enum('pending_review', 'finalized') [default: 'pending_review']
  finalized_at datetime
  created_at timestamp
  updated_at timestamp
}

Table score_reviews {
  id bigint [pk, increment]
  session_id bigint [ref: > exam_sessions.id]
  question_id bigint [ref: > question_bank.id]
  reviewed_by bigint [ref: > users.id]
  original_score int
  adjusted_score int
  notes text
  reviewed_at datetime
  created_at timestamp
}
```

</details>