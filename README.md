**Taskify – Flutter Task Management App
**
Taskify is a simple task management app built with Flutter and Firebase.
It was developed as part of an interview assignment to demonstrate clean architecture, state management, and real-time data handling.

**Features**
Email login
Create, update, delete tasks
Share tasks with other users via email
Real-time sync using Firestore
MVVM structure using Riverpod
Clean and reusable UI components

**Architecture Overview**
The project follows MVVM and uses Riverpod for state management.
The folder structure is organized as:

lib/
├── core/                     # Firebase services & utilities
├── di/                       # Riverpod providers
├── models/                   # Data models
├── viewmodels/               # Business logic (MVVM)
└── views/                    # UI screens and widgets


**Key components:**
FirebaseService handles CRUD and real-time streams
ShareService uses Share Plus for sharing
TaskListViewModel manages task state
Components folder contains smaller UI widgets (tiles, input fields, etc.)

**Tech Stack**
Flutter
Firebase (Auth + Firestore)
Riverpod
GoRouter
Share Plus

**Code Style**

Follows standard Dart/Flutter conventions
Widgets kept small and reusable
ViewModels contain business logic; UI stays clean

**Screenshots**

<img width="1080" height="2400" alt="Screenshot_20251205_182531" src="https://github.com/user-attachments/assets/089d4ecc-f725-4046-832f-37dd5123a782" />
<img width="1080" height="2400" alt="Screenshot_20251205_182604" src="https://github.com/user-attachments/assets/7c2515c9-e069-4cc1-b8ba-55ea81faabed" />
<img width="1080" height="2400" alt="Screenshot_20251205_182639" src="https://github.com/user-attachments/assets/294244dd-dedf-45c8-8f4a-dddc47f25782" />
<img width="1080" height="2400" alt="Screenshot_20251205_182647" src="https://github.com/user-attachments/assets/8aff79a1-67a9-45c5-9c06-3c40d6694938" />
<img width="1080" height="2400" alt="Screenshot_20251205_182700" src="https://github.com/user-attachments/assets/8ffb9403-558c-4679-aace-32fcb9737667" />
