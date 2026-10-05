---
layout: page
title: MZS TOEFL Course CBT
permalink: /projects/mzstoeflcbt
---

# MZS TOEFL Course CBT

**MZS TOEFL Course CBT** is a Computer-Based Test (CBT) platform for TOEFL courses that lets students register, purchase test access, and take scheduled TOEFL examinations online. It covers the full test lifecycle, from question management and exam scheduling to automated scoring, manual review, and detailed result reporting. Built with Laravel and MySQL, it uses Xendit for payments and is deployed on a VPS.

<img src="https://placehold.co/860x400?text=TOEFL+CBT+Cover" alt="MZS TOEFL Course CBT cover" class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack Developer |
| **Type** | Web Application (CBT Platform) |
| **Stack** | PHP, Laravel, MySQL, Blade, Xendit |
| **Architecture** | Monolithic MVC with webhook-based payment confirmation |
| **Deployment** | VPS |
| **Completed** | October 2022 |
| **Status** | Delivered and used for TOEFL course exams |

---

## Problem & Goals

### Problem
Running TOEFL practice exams requires reliable timing, controlled access, and consistent scoring. Doing this without a dedicated system makes it hard to schedule participants, protect exam integrity, grade quickly, and collect payments.

### Goals
- Let students register, pay once, and book an exam slot online.
- Deliver exams with a dependable timer and automatic submission on timeout.
- Score objective questions automatically while allowing trainers to review flagged items.
- Give students immediate results with a score breakdown per section.
- Give administrators and trainers tools to manage the question bank, schedules, and student progress.

---

## My Contributions

- Designed a 12-table relational schema covering users, question bank, exam scheduling, sessions, answers, scoring, and payments.
- Implemented the CBT interface with a section-by-section flow, timer, and auto-submit on timeout.
- Built the question bank, including bulk import from Excel and Word files.
- Implemented the dual scoring system (automatic scoring plus manual review) and the result reports.
- Integrated **Xendit** for one-time payments with webhook-based confirmation.
- Implemented four-role access control and deployed the application to a VPS.

---

## Key Features

### Platform (Superadmin)
- **User Management** - Manage all users across the admin, trainer, and student roles.
- **Platform Settings** - Configure global settings, scoring rules, and test parameters.
- **Platform Analytics** - Overview of registered students, active exams, revenue, and test completion rates.

### Course Management (Admin & Trainer)
- **Question Bank Management** - Create, edit, and organize questions across the three TOEFL sections: Listening Comprehension, Structure & Written Expression, and Reading Comprehension.
- **Bulk Question Import** - Import questions from Excel or Word files to speed up question bank setup.
- **Exam Scheduling** - Create exam periods with start and end dates, so students can choose a preferred slot within the period.
- **Result Review** - Manually review and override scores for open-ended or flagged responses alongside automated scoring.
- **Student Progress Tracking** - Monitor individual performance, test history, and score trends.

### Student
- **Course Registration** - Register and purchase test access through a one-time Xendit payment.
- **Exam Booking** - Select a preferred test slot within the available exam periods.
- **CBT Interface** - Take the exam with a built-in timer, section-by-section navigation, and auto-submit on timeout.
- **Score & Results** - View detailed results right after grading, including the total score and a breakdown per section (Listening, Structure, Reading).
- **Result History** - Review past results and score progression over time.

---

## Architecture

The application follows the standard Laravel MVC request flow. Payment confirmation arrives asynchronously through a Xendit webhook, so the application never depends on the student's browser to confirm a payment.

<pre><code>Browser -&gt; Laravel Routes -&gt; Middleware (auth, role) -&gt; Controller
        -&gt; Eloquent Models -&gt; MySQL
        -&gt; Blade View -&gt; HTML Response

Xendit -&gt; Webhook Route -&gt; Controller -&gt; payments / registrations
</code></pre>

### Exam Flow

1. Student registers and completes a one-time payment via Xendit.
2. Student selects an available exam slot within the scheduled period.
3. On exam day, student enters the CBT interface and the timer starts automatically.
4. The system auto-submits when time runs out.
5. Objective questions are scored automatically, and flagged items go to trainer review.
6. The final score is published with a section breakdown (Listening, Structure, Reading).

### Exam Scheduling Model

| Level | Table | Purpose |
|---|---|---|
| **Period** | `exam_periods` | A batch with start and end dates, for example "TOEFL Batch October 2022" |
| **Slot** | `exam_slots` | A date and time within a period, with duration and a participant limit |
| **Session** | `exam_sessions` | One student's booking of a slot, with timer fields and status |

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Periods, slots, and sessions as separate tables | Models capacity per slot (`max_participants`) and lets students choose a time within a batch | More joins and more booking rules to validate |
| `started_at`, `submitted_at`, and `auto_submitted` on `exam_sessions` | Server-side timing makes the timer reliable and shows whether a session was submitted by the student or by timeout | Requires careful handling of clock and connection edge cases |
| Session `status` (`booked`, `in_progress`, `completed`, `cancelled`) | Prevents re-entry into a completed exam | Every exam route must check the status |
| Automatic scoring plus `score_reviews` | Fast grading for objective questions, with an audit trail (original and adjusted scores, reviewer, notes) for manual overrides | Scores stay `pending_review` until a trainer finalizes them |
| `question_options` in a separate table | Supports a variable number of options and clean answer storage | Extra join when loading a question |
| Xendit invoices with webhook confirmation | Payment status is confirmed by the gateway rather than the browser | Needs idempotent webhook handling and a public endpoint |
| Monolithic MVC with Blade | Simple to build, deploy, and maintain on a single VPS | Less interactive than a single-page application |

---

## Tech Stack

| Technology | Purpose |
|---|---|
| PHP & Laravel | Backend framework, routing, business logic |
| MySQL | Relational database for questions, exams, and results |
| Blade Templating | Server-side rendered frontend views |
| Xendit | Payment gateway for the one-time student registration payment |
| VPS | Deployment environment |

---

## Roles & Access

| Role | Access |
|---|---|
| **Superadmin** | Full platform access to users, settings, analytics, and all data |
| **Admin** | Course management: question bank, exam scheduling, student results, and reports |
| **Trainer** | Question management, result review, and student progress monitoring |
| **Student** | Registration, exam booking, CBT interface, and personal results |

---

## Security & Exam Integrity

- **Authentication** - Login required for every page, with four roles controlling access.
- **Re-entry Protection** - A student cannot re-enter an exam that is already completed.
- **Reliable Timing** - Session start and submission times are recorded, and the system auto-submits on timeout.
- **Payment Confirmation** - Payments are confirmed through the Xendit webhook, and each payment is tied to a unique invoice ID.
- **Credentials** - Passwords are stored as hashes, never as plain text.
- **Data Integrity** - Foreign keys and unique constraints (such as one score per session) prevent inconsistent records.

---

## Data Model

Designed with 12 tables covering platform users, question bank, exam scheduling, student registrations, exam sessions, answers, scoring, and payments. All relationships are enforced with foreign keys.

| Table | Description |
|---|---|
| `users` | All platform users with a role (superadmin / admin / trainer / student) |
| `courses` | Available TOEFL courses with pricing and description |
| `registrations` | Student course registrations with payment status |
| `payments` | Xendit payment records per registration |
| `question_bank` | Questions categorized by section type and difficulty |
| `question_options` | Answer options per question |
| `exam_periods` | Scheduled exam periods with start and end dates |
| `exam_slots` | Available time slots within each exam period |
| `exam_sessions` | Student exam sessions linked to a slot, with timer and status |
| `student_answers` | Student answers per question per session |
| `scores` | Final scores per session with a section breakdown |
| `score_reviews` | Manual review records by trainers for flagged answers |

<img src="{{ site.baseurl }}/assets/projects/mzstoeflcbt/database-design.png" alt="MZS TOEFL CBT database design ERD" class="img-fluid rounded" onerror="this.style.display='none'" />

> View the full ERD on [dbdiagram.io](https://dbdiagram.io) by pasting the DBML below.

<details>
<summary>Show DBML schema</summary>

<pre><code>// MZS TOEFL Course CBT - Database Schema
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
  student_id bigint [ref: &gt; users.id]
  course_id bigint [ref: &gt; courses.id]
  payment_status enum('pending', 'paid', 'failed', 'expired') [default: 'pending']
  registered_at timestamp
  created_at timestamp
  updated_at timestamp
}

Table payments {
  id bigint [pk, increment]
  registration_id bigint [ref: &gt; registrations.id]
  xendit_invoice_id varchar(100) [unique, note: 'Xendit invoice ID']
  xendit_payment_method varchar(50) [note: 'e.g. BCA, OVO, DANA, credit_card']
  amount decimal(15,2) [not null]
  status enum('pending', 'paid', 'failed', 'expired') [default: 'pending']
  paid_at datetime
  created_at timestamp
}

Table question_bank {
  id bigint [pk, increment]
  course_id bigint [ref: &gt; courses.id]
  section enum('listening', 'structure', 'reading') [not null]
  question_text text [not null]
  audio_url varchar(255) [note: 'For listening section questions']
  passage_text text [note: 'For reading section questions']
  correct_option_id bigint [note: 'FK set after options are created']
  scoring_type enum('auto', 'manual') [default: 'auto']
  difficulty enum('easy', 'medium', 'hard') [default: 'medium']
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table question_options {
  id bigint [pk, increment]
  question_id bigint [ref: &gt; question_bank.id]
  option_label varchar(5) [not null, note: 'A, B, C, D']
  option_text text [not null]
  created_at timestamp
}

Table exam_periods {
  id bigint [pk, increment]
  course_id bigint [ref: &gt; courses.id]
  name varchar(150) [not null, note: 'e.g. TOEFL Batch October 2022']
  start_date date [not null]
  end_date date [not null]
  is_active boolean [default: true]
  created_by bigint [ref: &gt; users.id]
  created_at timestamp
  updated_at timestamp
}

Table exam_slots {
  id bigint [pk, increment]
  period_id bigint [ref: &gt; exam_periods.id]
  slot_datetime datetime [not null]
  duration_minutes int [not null, default: 115]
  max_participants int [not null]
  created_at timestamp
}

Table exam_sessions {
  id bigint [pk, increment]
  student_id bigint [ref: &gt; users.id]
  slot_id bigint [ref: &gt; exam_slots.id]
  status enum('booked', 'in_progress', 'completed', 'cancelled') [default: 'booked']
  started_at datetime
  submitted_at datetime
  auto_submitted boolean [default: false, note: 'True if submitted by timer']
  created_at timestamp
  updated_at timestamp
}

Table student_answers {
  id bigint [pk, increment]
  session_id bigint [ref: &gt; exam_sessions.id]
  question_id bigint [ref: &gt; question_bank.id]
  selected_option_id bigint [ref: &gt; question_options.id, null]
  is_correct boolean
  created_at timestamp
}

Table scores {
  id bigint [pk, increment]
  session_id bigint [ref: &gt; exam_sessions.id, unique]
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
  session_id bigint [ref: &gt; exam_sessions.id]
  question_id bigint [ref: &gt; question_bank.id]
  reviewed_by bigint [ref: &gt; users.id]
  original_score int
  adjusted_score int
  notes text
  reviewed_at datetime
  created_at timestamp
}
</code></pre>

</details>

---

## Results & Impact

- Delivered a complete online TOEFL exam workflow, from registration and payment to scheduling, timed testing, scoring, and result history.
- Built around **exam integrity and timing**: a reliable timer, correct auto-submission on timeout, and protection against re-entering a completed exam.
- Combined automated scoring with manual review, which adds flexibility for complex or flagged questions.
- Handled one-time payments cleanly through Xendit with webhook-based confirmation.