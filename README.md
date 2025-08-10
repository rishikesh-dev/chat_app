# 🗨️ Chat App

A clean and modern real-time **one-to-one chat application** built with **Flutter**, using **Supabase** as the backend and structured using **Clean Architecture** and **BLoC** for scalable state management.

---

## ✨ Features

- 🔐 **Authentication** with Firebase (email/password) 
- 💬 **Real-time one-to-one messaging**
- 😄 **Emoji picker** support
- 🔔 **Toast notifications** via `toastification`
- 💾 **Shared Preferences** for local data persistence (e.g., theme)
- 🎨 Light/Dark mode support with theme persistence
- 🧱 **Clean Architecture** structure for testability and maintainability

---

## 🧰 Tech Stack

| Layer           | Stack / Packages                              |
|------------------|-----------------------------------------------|
| Backend          | [Firebase](https://console.firebase.google.com/) (auth + DB)   |
| State Mgmt       | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Architecture     | Clean Architecture (feature-first foldering)  |
| Storage          | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Emoji Support    | [emoji_picker_flutter](https://pub.dev/packages/emoji_picker_flutter) |
| Notifications    | [toastification](https://pub.dev/packages/toastification) |
| UI Framework     | Flutter (Material Design)                     |

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/rishikesh-dev/chat_app.git
cd chat_app
