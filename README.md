# Scalaxity

A real-time collaborative task manager built with Flutter.

## Features

- Create, edit, delete tasks with title, description, due date, and status
- View tasks in a list format
- Real-time sync using Firestore
- Backend REST API for saving/loading tasks
- (Optional) Collaborative task lists and push notifications

## Architecture

- **Flutter Frontend:** Handles UI, authentication, and listens to Firestore for real-time updates.
- **Backend Service:** Provides REST API for CRUD operations. Updates Firestore for real-time sync.

## Backend Requirements

- Expose REST endpoints for tasks:
  - `GET /tasks`
  - `POST /tasks`
  - `PUT /tasks/:id`
  - `DELETE /tasks/:id`
- On each operation, update Firestore so clients receive real-time updates.

## Getting Started

1. Clone this repository.
2. Install Flutter and dependencies.
3. Set up Firebase and Firestore for your project.
4. Configure your backend service and update the API URL in `task_provider.dart`.
5. Run the app:

   ```sh
   flutter pub get
   flutter run
   ```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)

## License

MIT
