<div align="center">

<img src="assets/images/common/logo.png" alt="Kido Logo" width="120" height="120" />

# Kido — Special Needs Educational App

**A structured, play-based learning system designed for children with special needs.**  
Parents track progress. Children learn at their own pace. Every level builds on the last.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Backend-339933?style=flat-square&logo=nodedotjs)](https://nodejs.org)
[![Prisma](https://img.shields.io/badge/Prisma-ORM-2D3748?style=flat-square&logo=prisma)](https://prisma.io)
[![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=flat-square&logo=mysql)](https://mysql.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

</div>

---

## What is Kido?

Kido is a mobile application built for children with special needs, offering a carefully sequenced curriculum across three learning levels. Each level has a clear educational goal — from building basic motor awareness and sensory recognition, to pre-academic readiness, to foundational academic skills like letters, numbers, and vocabulary.

Parents register and manage their children's accounts, monitor progress, and unlock new levels based on assessment results. Children interact with a dedicated, child-friendly interface that guides them through lessons using audio, animation, and interactive activities.

---

## Learning Curriculum

Kido's curriculum is divided into three progressive levels. A child cannot advance to the next level until they pass an assessment with a score of 70% or above.

### Level 1 — Movement & Perception
> *Goal: Build the cognitive and motor foundations children need before any academic learning begins.*

Level 1 focuses on sensory awareness, physical coordination, and basic cognitive skills. Children explore how their bodies move, how to recognize and sort objects, and how to express emotions. These activities develop the perceptual and motor groundwork that all future learning depends on.

| Category | Description |
|----------|-------------|
| Counting | Recognizing quantities from 1 to 4 through visual and interactive exercises |
| Sorting | Grouping objects by shared properties |
| Pegboard | Fine motor activities using peg-based patterns |
| Senses | Identifying sights, sounds, smells, taste, and touch |
| Matching | Pairing identical or related items |
| Drawing | Free and guided mark-making to build hand control |
| Self Care | Basic daily routines such as washing hands and getting dressed |
| Feelings | Recognizing and naming emotions through illustrated scenarios |

---

### Level 2 — Pre-Academic Readiness
> *Goal: Bridge the gap between physical awareness and structured academic learning.*

Level 2 introduces children to concepts they will need to understand written language and mathematical ideas — size, dimension, and shape. Activities involve drawing structured lines and comparing objects by their physical properties.

| Category | Description |
|----------|-------------|
| Draw Line | Tracing horizontal, vertical, diagonal, curved, and zigzag lines |
| Big / Small | Comparing objects by size |
| Tall / Short | Comparing objects by height |
| Thin | Recognizing width differences |
| Shapes | Identifying circles, squares, triangles, and rectangles |

---

### Level 3 — Academic Foundations
> *Goal: Introduce core academic content — letters, numbers, and everyday vocabulary.*

Level 3 moves into structured academic learning. Children are introduced to the Arabic and English alphabets, numbers, colors, and categories from the world around them — fruits, vegetables, animals, and family members. This level uses audio, images, and interactive screens to support retention.

| Category | Lessons |
|----------|---------|
| Letters | 20 lessons covering the Arabic alphabet |
| Numbers | 10 lessons covering numerals and their values |
| Colors | Visual color recognition |
| Fruits | Common fruit names with matching images and audio |
| Vegetables | Common vegetable names with matching images and audio |
| Family | Family member names and roles |
| Animals | 6 lessons on common animals with sounds and images |

---

## System Architecture

Kido is a full-stack system made up of two repositories:

```
KidoSystem/          ← Flutter mobile app (this repo)
KidoBackend/         ← Node.js REST API + MySQL database
```

```
Flutter App
    │
    │  HTTP + JWT
    ▼
server.js  ──→  authmiddleware.js
    │
    ├──→  /api/auth         authController      (register, login, OTP)
    ├──→  /api/child        ChildController     (child accounts, home screen)
    ├──→  /api/assessment   assessmentController (submit scores, unlock levels)
    └──→  /api/progress     progressController  (complete lessons, view progress)
    │
    ▼
Prisma ORM  ──→  MySQL Database
                 (users, children, levels, categories, lessons, progress, assessments)
```

---

## Tech Stack

### Mobile — Flutter
| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `dio` | HTTP client for API calls |
| `shared_preferences` / `flutter_secure_storage` | Local storage and token persistence |
| `audioplayers` + `flutter_tts` | Audio playback and text-to-speech |
| `lottie` + `rive` | Animations |
| `speech_to_text` | Voice input |
| `video_player` | Lesson video content |
| `signature` | Drawing activity input |
| `confetti` + `flip_card` | Interactive feedback and UI effects |
| `flutter_animate` + `motion_toast` | UI animations and notifications |
| `smooth_page_indicator` | Level and lesson navigation |

### Backend — Node.js
| Technology | Purpose |
|-----------|---------|
| Express.js | REST API framework |
| Prisma ORM | Database access layer |
| MySQL | Primary database |
| JWT | Authentication tokens |
| bcryptjs | Password hashing |
| Nodemailer | OTP email delivery |

---

## Key Features

**For parents**
- Register and manage multiple child accounts
- View each child's completed lessons and current level
- Track assessment history and scores
- Receive OTP-verified account registration

**For children**
- Age-appropriate, distraction-free interface
- Audio narration and animated feedback throughout
- Structured lessons with clear progression
- Level access controlled by parent-verified assessments

**Assessment system**
- Children take a level assessment after completing lessons
- Passing score (≥ 70%) automatically unlocks the next level
- Full history of scores stored per child

---

## Getting Started

### Prerequisites
- Flutter SDK `^3.7.2`
- Dart SDK `^3.7.2`
- Node.js `18+`
- MySQL database

### Flutter setup
```bash
git clone https://github.com/AyatNagy/KidoSystem.git
cd KidoSystem
flutter pub get
flutter run
```

### Backend setup
```bash
git clone <backend-repo-url>
cd KidoBackend
npm install
```

Create a `.env` file:
```env
DATABASE_URL="mysql://user:password@localhost:3306/kido_db"
JWT_SECRET="your_secret_key"
EMAIL="your_email@gmail.com"
EMAIL_PASS="your_app_password"
PORT=3000
```

Run migrations and seed the database:
```bash
npx prisma migrate dev
npx prisma generate
node prisma/seed.js
```

Start the server:
```bash
node src/server.js
```

---

## API Overview

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/auth/register` | — | Register a new parent account |
| `POST` | `/api/auth/verify-otp` | — | Verify email with OTP |
| `POST` | `/api/auth/login` | — | Parent login, returns JWT |
| `POST` | `/api/auth/forget` | — | Request password reset OTP |
| `POST` | `/api/auth/reset-password` | — | Set new password |
| `POST` | `/api/child/register` | Parent | Register a child under this account |
| `POST` | `/api/child/login` | — | Child login, returns child JWT |
| `GET` | `/api/child/my` | Parent | Get all children with progress summary |
| `PUT` | `/api/child/set-level` | Parent | Set a child's allowed level |
| `POST` | `/api/assessment/submit` | Child | Submit assessment score |
| `GET` | `/api/assessment/child/:id` | Parent | Get assessment history for a child |
| `POST` | `/api/progress/complete` | Child | Mark a lesson as completed |
| `GET` | `/api/progress/my` | Child | Get full progress grouped by level |

---

## Project Structure (Flutter)

```
lib/
├── core/              # Theme, constants, shared utilities
├── data/              # API service layer, models, repositories
├── features/
│   ├── auth/          # Parent registration, login, OTP
│   ├── child/         # Child login, child home screen
│   ├── level1/        # Movement & Perception lessons
│   ├── level2/        # Pre-Academic Readiness lessons
│   ├── level3/        # Academic Foundations lessons
│   ├── assessment/    # Assessment screens
│   └── progress/      # Progress tracking screens
└── main.dart
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## Team

Built as a graduation project by a team passionate about making education accessible for every child.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.