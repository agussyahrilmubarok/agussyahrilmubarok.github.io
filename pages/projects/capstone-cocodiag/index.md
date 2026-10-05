---
layout: page
title: CocoDiag
permalink: /projects/cocodiag
---

# CocoDiag

**CocoDiag** is an AI-powered Android application that diagnoses coconut plant diseases from a single photo and gives farmers actionable treatment guidance. Built with Kotlin, TensorFlow, Flask, and Google Cloud, it focuses on diagnostic reliability, a smooth camera-to-result experience, and farmer-to-farmer knowledge sharing.

<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/CocoDiag+Cover.png" alt="Cover image. Suggested: a composite of three app screens (camera, diagnosis result, forum) on a device mockup with the CocoDiag logo." class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Mobile Developer (Android) |
| **Type** | Android application with REST API backend and ML image classifier |
| **Stack** | Kotlin, CameraX, Retrofit, TensorFlow/Keras, Flask, Firebase, Google Cloud Run |
| **Architecture** | MVVM + Repository (client), modular REST API with blueprints (server) |
| **Deployment** | Google Cloud Run (Docker), Firebase, GitHub Actions (Android CI) |
| **Duration** | 2024 (Bangkit Academy Product Capstone) |
| **Team** | 7 members (3 Machine Learning, 2 Cloud Computing, 2 Mobile Development) |
| **Status** | Completed capstone project |

---

## Problem & Goals

### Problem
Indonesia is the world's second-largest coconut producer, yet plant diseases can cause losses of up to 30%. Farmers without agronomy training often cannot identify a disease early enough to act. Existing research and tools stop at detection: no publicly available application combined coconut disease diagnosis with treatment advice and a community to learn from.

### Goals
- Classify five common coconut diseases from one photo taken on a phone.
- Return the diagnosis together with symptoms, causes, and concrete control steps.
- Avoid misleading farmers by rejecting low-confidence predictions instead of guessing.
- Provide a community forum where farmers can share experience and ask questions.
- Surface market context (coconut prices) and curated research articles in the same app.

### Constraints
- Capstone timeline and a seven-person team spread across three disciplines.
- A limited dataset (about 4,500 images across five classes).
- Unreliable mobile connectivity in farming areas, which the client had to tolerate gracefully.
- Photos vary widely in orientation, size, and quality, depending on the device and the user.

---

## My Contributions

- Designed and implemented the Android client using **MVVM with a Repository layer**, a sealed `ResultState` (Loading / Success / Error) exposed through LiveData, and manual dependency injection via a `ViewModelFactory`.
- Built the **camera-to-diagnosis flow** on CameraX: orientation-aware capture, gallery import, EXIF rotation correction, and adaptive JPEG compression to keep uploads under 3 MB.
- Implemented the networking layer with **Retrofit and OkHttp**, including a JWT interceptor, extended timeouts for inference calls, and structured error mapping from API responses.
- Added **connectivity monitoring** (`NetworkCallback`) with a retry dialog, so the app fails clearly instead of silently when offline.
- Delivered the **community forum** UI: posts with images, likes, comments, and per-user profile feeds.
- Built session handling with Jetpack DataStore, client-side input validation, onboarding, profile management, and diagnosis history screens.
- Set up **GitHub Actions CI** that builds the debug APK and runs unit tests on every push and pull request to `main`.
- Drafted the initial API contract with the Cloud Computing team to keep client and server aligned from the start.

---

## Key Features

### Core
- **Photo-based Diagnosis** - Capture or select a photo and receive the disease name, confidence score, symptoms, and treatment steps within seconds.
- **Confidence Gate** - Predictions below 75% confidence are rejected with a "retake photo" message, prioritizing trust over coverage.
- **Diagnosis History** - Every result is stored with its source image so farmers can track a plant over time and delete entries they no longer need.

### Platform
- **Community Forum** - Create image posts, like, comment, and browse any member's posts.
- **Market & Knowledge Feed** - Live coconut price from a public food-price dashboard and curated scientific articles on the home screen.
- **Authentication & Profiles** - Firebase-verified sign-in, custom JWT sessions, editable profile photo, and password change.
- **Onboarding** - A three-step introduction for first-time users.

---

## Demo

<a href="https://youtu.be/mEucYY-vJIk">
  <img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/Demo+Video.gif" alt="CocoDiag demo: diagnosis flow from camera to result" class="img-fluid rounded d-block mx-auto" />
</a>

### App Screens

<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/1-Onboarding.png" alt="Onboarding screen, first slide." class="rounded" />
<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/2-Camera.png" alt="Camera screen with the capture and gallery buttons." class="rounded" />
<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/3-Result.png" alt="Diagnosis result screen showing disease name, confidence, and the info dialog with symptoms and controls." class="rounded" />
<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/4-History.png" alt="Diagnosis history list screen." class="rounded" />

---

## Architecture

<img src="https://placehold.co/860x480?text=System+Architecture+Diagram" alt="REPLACE ME: System architecture diagram. Android app to Cloud Run API, which connects to Firebase Auth, Firestore, Firebase Storage, Cloud Storage (model and articles), and Secret Manager." class="img-fluid rounded" />

<pre><code>Android App (Kotlin, MVVM)
   -&gt; HTTPS + JWT -&gt; Flask API (Cloud Run)
                      -&gt; Firebase Auth       (credential verification)
                      -&gt; Firestore           (users, history, forum)
                      -&gt; Firebase Storage    (profile, forum, and diagnosis images)
                      -&gt; Cloud Storage       (ML model, class info, articles)
                      -&gt; Secret Manager      (JWT secret, service credentials)
                      -&gt; TensorFlow          (in-process inference)
</code></pre>

| Component | Responsibility | Technology |
|---|---|---|
| **Android Client** | UI, camera capture, session, API integration | Kotlin, CameraX, Retrofit, DataStore |
| **REST API** | Auth, prediction, history, forum, news, price | Flask, Flask-JWT-Extended, Gunicorn |
| **Inference** | Image preprocessing and disease classification | TensorFlow 2.16, MobileNetV2 |
| **Database** | Users, diagnosis history, posts, likes, comments | Cloud Firestore |
| **Object Storage** | User images and ML artifacts | Firebase Storage, Cloud Storage |
| **Secrets** | Credentials and signing keys | Google Secret Manager |

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| MobileNetV2 transfer learning over deeper ResNet backbones | Better generalization and far cheaper inference on the same data | Lower capacity if more classes are added later |
| In-process inference, model loaded once at startup | No extra service to operate, and no model reload per request | Slower cold starts on Cloud Run and a heavier container image |
| Firebase Auth for verification plus a custom JWT | Managed credential security, with a stateless API session the app controls | Two token systems to reason about |
| Likes and comments as Firestore sub-collections | Idempotent likes (one document per user) and scalable comment lists | Counters must be kept consistent manually |
| Manual DI (`Injection` + `ViewModelFactory`) | Minimal dependencies and an easy-to-follow graph for a small team | More boilerplate than Hilt as the app grows |

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Language** | Kotlin 1.9 | Android application |
| **UI** | XML + ViewBinding, Material Components, Lottie | Screens and animations |
| **Camera** | CameraX 1.3 | Capture with lifecycle-aware preview |
| **Networking** | Retrofit 2.9, OkHttp, Gson | REST integration |
| **Local Storage** | Jetpack DataStore | Session persistence |
| **Imaging** | Glide, ExifInterface | Image loading, rotation, compression |
| **Backend** | Python 3.11, Flask 3, Gunicorn | REST API |
| **ML** | TensorFlow/Keras 2.16, MobileNetV2 | Image classification |
| **Data** | Firebase Auth, Firestore, Storage | Identity, data, and media |
| **Container** | Docker, Google Cloud Run | Packaging and serverless hosting |
| **CI** | GitHub Actions (JDK 17) | Android build and unit tests |

---

## Machine Learning

The classifier was developed by the ML team in Google Colab on 4,574 labeled images across five classes: Bud Root Dropping, Bud Rot, Gray Leaf Spot, Leaf Rot, and Stem Bleeding.

| Experiment | Input | Result |
|---|---|---|
| ResNet50 (frozen) + dense head | 150 x 150 | About 72% validation accuracy, with clear overfitting (about 93% train) |
| ResNet152V2 (frozen) + dense head | 150 x 150 | About 85% validation accuracy, about 99% train, roughly 18 min per epoch |
| **MobileNetV2 (frozen) + softmax head** | **224 x 224** | **98.5% test accuracy after only 5 epochs** |

The final model was evaluated on a held-out test set of 460 images (80/10/10 split):

| Class | Precision | Recall | F1 | Support |
|---|---|---|---|---|
| Bud Root Dropping | 1.00 | 1.00 | 1.00 | 52 |
| Bud Rot | 1.00 | 0.98 | 0.99 | 47 |
| Gray Leaf Spot | 1.00 | 0.95 | 0.98 | 133 |
| Leaf Rot | 0.96 | 1.00 | 0.98 | 168 |
| Stem Bleeding | 1.00 | 1.00 | 1.00 | 60 |

<img src="{{ site.baseurl }}/assets/projects/capstone-cocodiag/Training+Curves+and+Confusion+Matrix.png" alt="REPLACE ME: Training and validation curves, plus the confusion matrix exported from the final notebook." class="img-fluid rounded" />

> The experiments used different input sizes and evaluation sets (validation vs. test), so the comparison is directional rather than strictly like-for-like.

---

## API Design

The API follows REST conventions with JSON payloads, multipart uploads for images, and Bearer-token authentication on every endpoint except sign-up and sign-in.

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/signup` | Register a new account | Public |
| `POST` | `/signin` | Verify credentials and issue a JWT | Public |
| `POST` | `/predict` | Classify an uploaded plant image and store the result | User |
| `GET` | `/history/<user_id>` | List the user's past diagnoses | Owner |
| `DELETE` | `/history/<user_id>/<history_id>` | Delete one diagnosis and its image | Owner |
| `GET` | `/forum?limit=20` | Latest forum posts | User |
| `POST` | `/forum` | Create a post with optional image | User |
| `POST` | `/forum/like` | Like or unlike a post | User |
| `POST` | `/forum/comment` | Comment on a post | User |
| `DELETE` | `/forum/<post_id>` | Delete a post | Owner |
| `GET` | `/getNews` | Curated coconut research articles | User |
| `GET` | `/getPrice` | Current coconut price | User |

The full service exposes 20+ endpoints, covering users, images, comments, and per-user post feeds.

<details>
<summary>Show example request and response</summary>

<pre><code>POST /predict
Content-Type: multipart/form-data
Authorization: Bearer &lt;access_token&gt;

imageFile: &lt;leaf_photo.jpg&gt;
</code></pre>

<pre><code>HTTP/1.1 200 OK

{
  "label": "Bud Rot",
  "accuracy": "97.48%",
  "name": "Bud Rot",
  "caused_by": "...",
  "symptoms": ["..."],
  "controls": ["..."],
  "created_at": 1718100000
}
</code></pre>

*Values are illustrative.*

</details>

---

## Data Model

| Collection | Description |
|---|---|
| `users` | Profile data: name, email, profile image URL |
| `history` | One document per diagnosis: owner, result payload, image URL, timestamp |
| `forum` | Posts with text, optional image, like and comment counters |
| `forum/{id}/likes` | One document per user who liked the post (guarantees idempotency) |
| `forum/{id}/comments` | Comments with author, text, and timestamp |

<img src="https://placehold.co/860x500?text=Firestore+Data+Model" alt="REPLACE ME: Firestore data model diagram showing users, history, forum, and the likes and comments sub-collections." class="img-fluid rounded" />

<details>
<summary>Show document structure</summary>

<pre><code>users/{uid}
  name, email, imageProfile

history/{id}
  user_id, image, image_url, created_at
  result { label, accuracy, name, caused_by, symptoms[], controls[] }

forum/{postId}
  user_id, post_text, post_image, count_like, count_comment,
  created_at, updated_at
  likes/{uid}        { liked, created_at }
  comments/{id}      { user_id, comment, created_at }
</code></pre>

</details>

---

## Security

- **Authentication** - Credentials are verified by Firebase Authentication; the API then issues a signed JWT with a one-week lifetime.
- **Authorization** - Diagnosis history is restricted to its owner (403 otherwise), and only authors can delete their own posts and comments.
- **Input Validation** - Server-side checks for required fields, normalized email validation, and an image extension allow-list. The client enforces name, email, and password-strength rules.
- **Secrets Management** - The JWT signing key, Firebase credentials, and API keys are loaded from Google Secret Manager and never committed to the repository.
- **Private Media** - Diagnosis images are served through an authenticated endpoint, and the client loads them with an Authorization header.
- **Known Gaps** - The client currently caches the password for silent re-authentication. A refresh-token flow with encrypted storage is the planned replacement (see Roadmap).

---

## Infrastructure & CI/CD

| Component | Approach |
|---|---|
| **Backend Hosting** | Docker image (Python 3.11-slim, Gunicorn) deployed to Google Cloud Run |
| **Client Build** | Gradle with a version catalog; debug APK built in CI |
| **Configuration** | Secrets from Secret Manager, ML artifacts from Cloud Storage |

### Android CI Pipeline
1. **Checkout** - Retrieve the repository on every push and pull request to `main`.
2. **Set up JDK 17** - Consistent toolchain for Gradle and AGP 8.4.
3. **Build** - `assembleDebug` verifies the app compiles end to end.
4. **Test** - `testDebug` runs the unit test suite.

---

## Testing & Quality

| Type | Tooling | Scope |
|---|---|---|
| **Build verification** | GitHub Actions | Every push and pull request |
| **Unit** | JUnit | Baseline suite in CI; ViewModel and repository tests are planned |
| **Model evaluation** | scikit-learn | Held-out test set with a per-class report |
| **Manual / device** | Physical devices and emulators | Camera, gallery, and network-loss scenarios |

---

## Challenges & Solutions

| Challenge | Solution | Outcome |
|---|---|---|
| Deeper backbones overfit a small dataset | Compared ResNet50, ResNet152V2, and MobileNetV2, then chose the lightest model | Higher test accuracy with a smaller, faster model |
| Unreliable predictions on poor photos | Added a 75% confidence threshold in the API and a clear retake message in the app | Users are asked to retake photos rather than shown a doubtful diagnosis |
| Inconsistent photo orientation and size across devices | Applied EXIF-based rotation and adaptive JPEG compression before upload | Predictable uploads under 3 MB with correct image orientation |
| Slow inference and cold starts on a mobile connection | Extended client timeouts, added a loading state, and monitored connectivity | A clear flow on slow networks, with a retry path when offline |
| Client and server contracts drifting apart | Kept a shared API contract and aligned changes with the Cloud team | Most endpoints stayed in sync; a few stale client calls were identified for removal |

---

## Results & Impact

- Delivered a working end-to-end product: a mobile client, a deployed cloud API, and a trained classifier.
- Reached **98.5% test accuracy** across five coconut diseases, with a macro F1 of 0.99.
- Shipped a community forum, diagnosis history, price feed, and article feed alongside the core diagnosis feature.
- Presented as the team's product for the Bangkit 2024 capstone (Team C241-PS469).

---

## Lessons Learned

- **Trust is a product decision.** A confidence threshold trades coverage for reliability, and for health-related advice reliability should win.
- **Smaller models can win.** Matching model size to dataset size produced better accuracy and cheaper inference than going deeper.
- **Contracts need an owner.** A shared, versioned API contract would have prevented the stale client calls and the duplicate history-saving logic.
- **Mind the request count.** The forum feed fetches user details per post. Returning them in the feed payload would remove the N+1 pattern.
- **Treat credentials carefully from day one.** Token-based re-authentication with encrypted storage is safer than caching a password.

---

## Roadmap

- Replace stored credentials with refresh tokens and encrypted storage.
- Return author details in forum responses to remove N+1 requests.
- Cache the coconut price on a schedule instead of scraping per request, and separate inference from the web API.
- Expand test coverage to ViewModels and repositories, and disable verbose network logging in release builds.
- Add on-device inference (TensorFlow Lite) for offline diagnosis.
- Extend the dataset and evaluate with cross-validation and a leakage check across splits.

---

## Links

| | |
|---|---|
| **Source Code** | [github.com/agussmkertjhaan/CocoDiag](https://github.com/agussmkertjhaan/CocoDiag) |
| **Backend Repository** | [github.com/AffandraF/cocodiag-api](https://github.com/AffandraF/cocodiag-api) |
| **Demo Video** | [youtu.be/mEucYY-vJIk](https://youtu.be/mEucYY-vJIk) |
| **Project Overview** | [CocoDiag README](https://github.com/agussmkertjhaan/CocoDiag#readme) |