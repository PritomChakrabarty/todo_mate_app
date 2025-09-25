# TodoMate - A Flutter Todo App

TodoMate is a lightweight and efficient **task management app** built with **Flutter**, featuring **local persistence with SQLite** and **state management using Provider**.  
It is designed to demonstrate clean architecture, structured state management, and full CRUD operations in Flutter.  

---

## Key Features
- **Add Todos** – Create tasks with a title, description, and priority level.
- **Mark as Complete/Incomplete** – Toggle tasks easily using checkboxes.
- **Edit Todos** – Update title, description, and priority at any time.
- **Delete with Confirmation** – Prevent accidental deletions with a confirmation dialog.
- **Filter Todos** – Switch between:
  - All Tasks  
  - Completed Tasks  
  - Pending Tasks
- **Priority Highlighting** – Tasks are color-coded:
  - Low → Grey
  - Medium → Yellow
  - High → Red
- **Persistent Storage** – All tasks are saved locally using SQLite.
- **State Management** – Powered by Provider for clean and reactive UI updates.

---

## Architecture & Project Structure
The project follows a **Provider + Repository pattern**, separating concerns between UI, state management, and data persistence.  

