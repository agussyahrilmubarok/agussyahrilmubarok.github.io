---
layout: page
title: BinIQ
permalink: /projects/biniq
---

# BinIQ - Automated Waste Classification System

**BinIQ** is an end-to-end IoT and machine learning system that classifies waste as organic or inorganic and sorts it automatically with a servo-driven mechanism, while a native Android application gives operators a clear history of every classification. Built with ESP32 firmware, a TensorFlow MobileNetV2 model, a Flask inference service, Firebase Firestore, and Jetpack Compose, it focuses on practical edge-to-cloud integration, clean separation of concerns, and measurable model accuracy.

<img src="https://placehold.co/860x400?text=BinIQ+Cover" alt="Cover image. Replace with a photo of the assembled BinIQ prototype next to a screenshot of the Android dashboard." class="img-fluid rounded" />

---

## Overview

| | |
|---|---|
| **Role** | Full-Stack IoT Engineer (Firmware, Machine Learning, Mobile) |
| **Type** | IoT Device + ML Inference Service + Android Application |
| **Stack** | C++ (Arduino/ESP32), Python, TensorFlow/Keras, Flask, Kotlin, Jetpack Compose, Firebase |
| **Architecture** | Edge device + cloud inference, Clean Architecture on mobile (MVVM, Hilt) |
| **Deployment** | Self-hosted Flask server (LAN, tunneled with ngrok for testing), Firebase (Auth, Firestore), GitHub Actions CI |
| **Duration** | [Month YYYY - Month YYYY] |
| **Team** | Individual project |
| **Status** | Working prototype (academic final project, Kuningan Regency context) |

---

## Problem & Goals

### Problem
Source-level waste separation is inconsistent in practice. Mixed organic and inorganic waste lowers recycling quality and increases the burden on downstream waste management. Manual sorting does not scale, and local authorities have no reliable record of what is actually being disposed of. BinIQ was developed in the context of the Kuningan Regency Environmental Agency (DLH) to explore an affordable, automated alternative.

### Goals
- Classify waste into organic and inorganic categories automatically, with at least 94% accuracy on held-out data.
- Physically route each item to the correct bin without human intervention.
- Avoid false actions when no object is present by recognizing an explicit "no object" class.
- Provide an auditable record (photo, label, confidence, timestamp) accessible from a mobile app.
- Keep the hardware low-cost, using commodity ESP32 modules.

### Constraints
- Microcontroller limits: the ESP32-CAM has limited memory and no practical room for a full-precision CNN, which shaped the decision to run inference on a server.
- The device depends on local network availability to reach the inference service.
- Single-developer scope and an academic timeline.

---

## My Contributions

- Designed the overall system architecture across three subsystems (firmware, ML service, mobile app) and defined the contracts between them.
- Wrote the firmware for two ESP32 boards: ultrasonic triggering, LCD feedback, camera capture, multipart image upload, and servo control.
- Curated the dataset pipeline, trained the MobileNetV2 transfer-learning model, and exported it in multiple formats (Keras, SavedModel, TFLite, pickle).
- Built the Flask inference API with Firestore logging.
- Developed the Android application with Jetpack Compose, Hilt, and a layered domain/data architecture.
- Wrote unit tests for ViewModels, use cases, and repositories, and set up a GitHub Actions pipeline that builds, tests, and lints on every push.

---

## Key Features

### Core
- **Contactless Trigger** - An HC-SR04 ultrasonic sensor detects an item within a 10-20 cm window and signals the camera board, so the system only acts when waste is actually present.
- **Reliable Image Capture** - The camera board turns on a flash LED and discards several warm-up frames before taking the final shot, which lets auto-exposure settle and improves input quality.
- **AI Classification** - A MobileNetV2-based model classifies each image as organic, inorganic, or no object, and reaches 94.6% accuracy on the held-out test set.
- **Automatic Sorting** - A servo sweeps in opposite directions depending on the predicted class, then returns to its neutral position.
- **On-Device Feedback** - A 16x2 I2C LCD guides the user ("Insert waste wisely", "Waste is being classified") and is designed to display the result.

### Platform
- **Cloud Logging** - Every valid classification is stored in Firestore with its label, confidence score, Unix timestamp, and the captured image.
- **Mobile Dashboard** - The home screen shows today's organic and inorganic counts and the ten most recent records.
- **History by Date** - Operators can pick any date, browse its records, and open a detail dialog with the photo, accuracy, and time.
- **Connectivity Awareness** - The app detects network loss and informs the user instead of failing silently.

<img src="https://placehold.co/860x480?text=Android+App+Screens" alt="Android app screens. Replace with three screenshots: Home (daily counters and latest records), History (date picker and list), and the waste detail dialog." class="img-fluid rounded" />

---

## Architecture

<img src="https://placehold.co/860x480?text=System+Architecture+Diagram" alt="System architecture diagram. Replace with a diagram showing: ultrasonic sensor and LCD (ESP32), camera and servo (ESP32-CAM), Flask server with MobileNetV2, Firestore, and the Android app." class="img-fluid rounded" />

<pre><code>Ultrasonic sensor -&gt; ESP32 (slave) + LCD
                         | trigger signal (GPIO)
                         v
                  ESP32-CAM (master) -- JPEG over HTTP multipart --&gt; Flask API
                         ^                                              |
                         | class label (plain text)                     |-- MobileNetV2 inference
                         +----------------------------------------------|
                         |                                              +-- log --&gt; Firestore
                  Servo (sorting)                                                        |
                                                                                         v
                                                                              Android app (Compose)
</code></pre>

| Component | Responsibility | Technology |
|---|---|---|
| **Sensor Node** | Distance sensing, user guidance, trigger signal | ESP32, HC-SR04, I2C LCD |
| **Camera Node** | Image capture, upload, servo actuation | ESP32-CAM (AI-Thinker), servo, flash LED |
| **Inference Service** | Image preprocessing, classification, logging | Flask, TensorFlow 2.15, Pillow |
| **Data Store** | Classification history and authentication | Firebase Firestore, Firebase Auth |
| **Mobile App** | Dashboard, history, detail view | Kotlin, Jetpack Compose, Hilt |

### Hardware

| Part | Role |
|---|---|
| **ESP32-CAM (AI-Thinker)** | Camera, Wi-Fi, servo control |
| **ESP32 DevKit** | Ultrasonic reading and LCD display |
| **HC-SR04** | Object presence detection |
| **16x2 I2C LCD** | User feedback |
| **Servo motor** | Sorting mechanism |

<img src="https://placehold.co/860x480?text=Hardware+Wiring" alt="Hardware wiring photo or schematic. Replace with a labeled picture of the ESP32, ESP32-CAM, HC-SR04, LCD, and servo wiring." class="img-fluid rounded" />

### Key Design Decisions

| Decision | Rationale | Trade-off |
|---|---|---|
| Run inference on a server instead of the ESP32-CAM | The microcontroller lacks the resources for a full CNN, and a server lets the model be updated without reflashing devices | Requires network access and adds upload latency |
| Split the device into two boards | Isolates the real-time sensing and display loop from the heavier camera and networking work | Needs an inter-board signalling protocol |
| Transfer learning with a frozen MobileNetV2 backbone | Only 164,355 of 2,422,339 parameters are trained, making training feasible on a free Colab runtime | Accuracy plateaus without fine-tuning |
| Explicit "no object" class | Prevents false servo movements and keeps empty frames out of the log | Needs enough diverse background samples |
| Firestore as the app backend, with no custom REST layer | Removes a service to maintain and gives the app a managed, authenticated data source | Aggregation currently happens on the client, and image payloads are large |
| Clean Architecture on Android (data, domain, features) | Testable use cases and replaceable data sources | More boilerplate for a small app |

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Firmware** | C++ (Arduino, ESP32 core), ESP32Servo, LiquidCrystal_I2C | Device control |
| **ML** | TensorFlow 2.15, Keras, scikit-learn, Pandas, Matplotlib, Seaborn | Training and evaluation |
| **Model** | MobileNetV2 (ImageNet weights) | Transfer learning backbone |
| **Backend** | Python, Flask 3, Pillow, firebase-admin | Inference API and logging |
| **Database** | Firebase Firestore | Classification records |
| **Auth** | Firebase Authentication | App access |
| **Mobile** | Kotlin 1.9, Jetpack Compose, Material 3, Navigation Compose | UI |
| **DI** | Hilt | Dependency injection |
| **Testing** | JUnit, Mockito, MockK, coroutines-test | Unit tests |
| **CI** | GitHub Actions | Build, test, lint |
| **Training Env** | Google Colab | Model development |

---

## Machine Learning Pipeline

| Stage | Detail |
|---|---|
| **Dataset** | 25,734 images in 3 classes (organic, inorganic, no object) |
| **Split** | 80% train (20,587), 10% validation (2,574), 10% test (2,573) |
| **Preprocessing** | Resize to 224x224, rescale pixel values to [0, 1] |
| **Augmentation** | Rotation (40 degrees), zoom, shear, width/height shift, horizontal and vertical flip |
| **Model** | MobileNetV2 (frozen) -> GlobalAveragePooling2D -> Dense(128, ReLU) -> Dense(3, Softmax) |
| **Training** | Adam (learning rate 0.001), categorical cross-entropy, 10 epochs, batch size 32 |
| **Training time** | About 3 hours 13 minutes on Google Colab |
| **Export** | Keras (.h5, .keras), SavedModel, TFLite (about 2.67 MB), pickle for the server |

<img src="https://placehold.co/860x420?text=Training+Curves+and+Confusion+Matrix" alt="Training and validation accuracy/loss curves with the confusion matrix. Replace with exported figures from the notebook." class="img-fluid rounded" />

### Inference API

The inference service exposes a small HTTP interface designed for constrained clients: it accepts a raw JPEG and returns the class label as plain text, which the microcontroller can parse without a JSON library.

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/wasteclass/predict` | Classify an uploaded image (`multipart/form-data`, field `imageFile`) and return `organik`, `anorganik`, or `z` |
| `GET` | `/status` | Health check |

<details>
<summary>Show device upload example</summary>

<pre><code>POST /wasteclass/predict HTTP/1.1
Content-Type: multipart/form-data; boundary=dataMarker

--dataMarker
Content-Disposition: form-data; name="imageFile"; filename="object.jpg"
Content-Type: image/jpeg

&lt;binary JPEG&gt;
--dataMarker--
</code></pre>

<pre><code>HTTP/1.1 200 OK

organik
</code></pre>

</details>

---

## Data Model

Classification records are stored in a single Firestore collection.

| Field | Type | Description |
|---|---|---|
| `label` | string | Predicted class (`organik` or `anorganik`) |
| `accuracy` | number | Model confidence of the top prediction (0-1) |
| `unixtime` | number | Capture time in Unix seconds, used for range queries |
| `image` | string | Captured frame as a base64 data URL |

Records for the "no object" class are intentionally not written, so the history only contains real disposal events.

---

## Mobile Application

The Android app follows a layered Clean Architecture with MVVM.

| Layer | Contents |
|---|---|
| **data** | Firestore and Auth repository implementations, response models |
| **domain** | Repository interfaces, use cases (auto sign-in, count by label today, latest records, records by date), domain model |
| **features** | Splash, Home, History, About screens with their ViewModels and navigation |
| **di** | Hilt modules for Firebase, repositories, use cases, networking, and logging |
| **ui / utils** | Theme, shared components, time and image converters, connectivity state |

Each ViewModel exposes sealed UI states (`Loading`, `Content`, `Error`), and all business rules live in interface-backed use cases, which keeps them easy to mock and test.

---

## Security

- **Secrets Handling** - Credentials are injected through a git-ignored `firebase.properties` file locally and through repository secrets in CI. The Firebase Admin service-account key is excluded from version control.
- **Access Control** - The app authenticates to Firebase before reading any data.
- **Known Limitations** - The prototype uses a single shared app account and hardcoded network settings in the firmware. Moving to per-user authentication with Firestore Security Rules is listed in the roadmap below.

---

## CI & Quality

| Area | Approach |
|---|---|
| **Pipeline** | GitHub Actions on every push and pull request to `main`: build debug APK, run unit tests, run lint |
| **Unit Tests** | 16 tests covering ViewModels, use cases, and the auth repository, using Mockito, MockK, and coroutine test utilities |
| **Test Data** | Dedicated generators for domain and response models |
| **Model Evaluation** | Hold-out test set, classification report, and confusion matrix |
| **Environment Parity** | A library-version check script and pinned dependencies keep the server aligned with the training environment |

---

## Model Performance

| Split | Accuracy | Loss |
|---|---|---|
| **Training** | 96.24% | 0.096 |
| **Validation** | 94.72% | 0.147 |
| **Test** | 94.60% | 0.141 |

| Class | Precision | Recall | F1-score | Test samples |
|---|---|---|---|---|
| **Inorganic** | 0.95 | 0.93 | 0.94 | 1,163 |
| **Organic** | 0.94 | 0.96 | 0.95 | 1,401 |
| **No object** | 1.00 | 1.00 | 1.00 | 9 |

<!-- Metrics were measured on the 10% hold-out split in Google Colab (TensorFlow 2.15). The no-object class has only 9 test samples, so its score is indicative rather than conclusive. -->

---

## Challenges & Solutions

| Challenge | Solution | Outcome |
|---|---|---|
| Inconsistent exposure on the first captured frame | Turn on the flash and discard several warm-up frames before the final capture | Stable, usable images for classification |
| ESP32-CAM unable to run the classifier | Offloaded inference to a Flask service behind a minimal HTTP contract | Model can be improved without touching device firmware |
| Spurious detections on empty frames | Added an explicit "no object" class and skipped logging and actuation for it | Servo and database only react to real items |
| Camera board resetting under load | Disabled the brown-out detector and added automatic restart on capture failure | More resilient operation on a weak power supply |
| Model deserialization depending on exact library versions | Pinned versions and added a library check script | Reproducible server environment |

---

## Results & Impact

- Delivered a working prototype that spans sensing, capture, classification, physical sorting, and monitoring.
- Achieved 94.6% test accuracy with a model of about 2.67 MB when exported to TFLite.
- Produced a documented, tested, and CI-verified Android client suitable as a base for further development.

---

## Lessons Learned

- Splitting responsibilities across boards and services made each part simpler to reason about, but it makes interface contracts (signals, payloads, collection names) the most important thing to document and version.
- Strong headline accuracy is not enough. The rarest class, which decides whether the machine acts at all, needs the most careful data collection and evaluation.
- Treating the mobile app as a layered system with interface-driven use cases made testing straightforward, and surfaced where error handling needed to be stricter.

---

## Roadmap

- Replace the shared app account with per-user authentication and enforce Firestore Security Rules.
- Store images in Cloud Storage and keep only URLs in Firestore, then use Firestore count aggregation and real-time listeners to reduce reads and enable live updates.
- Improve the model with fine-tuning, early stopping, a larger and more diverse "no object" set, and validation on field-captured images.
- Serve the model from the Keras or TFLite format instead of pickle, and run the API behind a production WSGI server.
- Replace the fixed wait in the firmware with an explicit acknowledgement between the two boards, and move network settings to a configuration portal.
- Extend classification beyond two classes (for example plastic, paper, and metal) to support recycling workflows.

---

## Links

| | |
|---|---|
| **Android App** | [github.com/agussmkertjhaan/TA-Android](https://github.com/agussmkertjhaan/TA-Android) |
| **Firmware** | [github.com/agussmkertjhaan/TA-Firmware](https://github.com/agussmkertjhaan/TA-Firmware) |
| **Machine Learning** | [github.com/agussmkertjhaan/TA-ML](https://github.com/agussmkertjhaan/TA-ML) |
| **Demo Video** | [Replace with demo link](https://example.com) |