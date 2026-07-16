# Simple Task Tracker MVVM Design

Date: 2026-07-16

## Purpose

This study case teaches Flutter interns who have built Flutter projects before but have not used state management or Firebase yet.

The project is a Flutter Web app named **Simple Task Tracker**. It introduces:

- Provider as state management.
- Firebase Firestore as the database.
- A simple MVVM structure.
- Clear separation between UI, state logic, and data access.

The goal is not to build a complex task management product. The goal is to make the first Provider + Firebase + MVVM implementation easy to understand before students move to a more realistic case.

## Recommended Architecture

Use a **feature-first MVVM structure**. In this design, the `Provider` class acts as the ViewModel.

```text
View
  -> Provider as ViewModel
    -> Repository
      -> Firebase Firestore
```

The View must not access Firebase directly. The View reads state from `TaskProvider` and calls methods on `TaskProvider`. `TaskProvider` owns screen state and user actions. `TaskRepository` owns Firestore communication.

## Folder Structure

```text
lib/
  main.dart
  app.dart
  firebase_options.dart

  core/
    constants/
    utils/
    widgets/

  features/
    tasks/
      models/
        task_model.dart

      repositories/
        task_repository.dart

      providers/
        task_provider.dart

      views/
        task_list_page.dart
        task_form_page.dart

      widgets/
        task_card.dart
        task_filter_chips.dart
```

This avoids a full Clean Architecture folder split such as `data/`, `domain/`, and `presentation/`. That split is useful later, but it introduces too many concepts for a first Provider and Firebase study case.

## Feature Scope

The app supports these features:

1. Display tasks from Firestore.
2. Add a new task.
3. Edit an existing task.
4. Delete a task.
5. Change a task status.
6. Filter tasks by status.

Out of scope for this first study case:

- Authentication.
- Multi-user data ownership.
- Drag-and-drop Kanban interaction.
- Multiple projects or workspaces.
- Complex category management.
- Offline-first behavior.
- Automated testing as a primary learning objective.

## Data Model

The app uses one main model: `TaskModel`.

```text
Task
  id: string
  title: string
  description: string
  status: todo | doing | done
  priority: low | medium | high
  dueDate: DateTime?
  createdAt: DateTime
  updatedAt: DateTime
```

Firestore structure:

```text
tasks/
  {taskId}/
    title
    description
    status
    priority
    dueDate
    createdAt
    updatedAt
```

`dueDate` is optional so the form can stay simple. `createdAt` is set when a task is created. `updatedAt` is set when a task is created and updated. Timestamp assignment belongs in `TaskRepository`, not in the View.

## File Responsibilities

### `task_model.dart`

Defines `TaskModel` and data conversion helpers:

```text
TaskModel.fromFirestore(...)
TaskModel.toFirestore()
TaskModel.copyWith(...)
```

The model defines enums for task status and priority. This keeps allowed values explicit while still being simple enough for the lesson.

### `task_repository.dart`

Contains all Firebase Firestore access:

```text
getTasks()
addTask(task)
updateTask(task)
deleteTask(id)
```

For the first implementation, start with `Future<List<TaskModel>> getTasks()`. After students understand the basic flow, introduce `Stream<List<TaskModel>>` as an optional real-time enhancement.

### `task_provider.dart`

Acts as the ViewModel in the MVVM pattern.

State:

```text
List<TaskModel> tasks
bool isLoading
String? errorMessage
TaskStatus? selectedStatus
```

Actions:

```text
loadTasks()
addTask(...)
updateTask(...)
deleteTask(...)
changeStatus(...)
setFilterStatus(...)
```

The provider is responsible for loading state, error state, filtering, and calling the repository. It should not contain widget code.

### `task_list_page.dart`

Displays:

- Task list.
- Filter chips.
- Loading state.
- Empty state.
- Error state.
- Buttons or actions for add, edit, delete, and status change.

This file must not import Firebase directly.

### `task_form_page.dart`

Handles add and edit forms.

Minimum validation:

- `title` is required.
- `status` is required.
- `priority` is required.

### `task_card.dart` and `task_filter_chips.dart`

Contain smaller task UI components so page files stay readable.

## Data Flow

Loading tasks:

```text
TaskListPage opens
  -> context.read<TaskProvider>().loadTasks()
  -> TaskProvider sets isLoading = true
  -> TaskProvider calls TaskRepository
  -> TaskRepository reads Firestore
  -> TaskProvider stores tasks
  -> TaskProvider calls notifyListeners()
  -> TaskListPage rebuilds through Consumer or Selector
```

Adding, editing, deleting, and changing status:

```text
User submits form or clicks an action
  -> View calls a TaskProvider method
  -> TaskProvider clears previous error and sets loading state
  -> TaskProvider calls TaskRepository
  -> TaskRepository updates Firestore
  -> TaskProvider reloads data or updates the local list
  -> TaskProvider calls notifyListeners()
```

For the first lesson, use **reload after add, update, and delete**. Optimistic local update is a useful follow-up topic but not needed in this study case.

## UI States

The app should explicitly teach four UI states:

- Loading state.
- Empty state.
- Error state.
- Success or data state.

Error handling should use a simple pattern:

```text
try
  set loading
  call repository
catch
  store errorMessage
finally
  stop loading
```

## Learning Sequence

Recommended teaching order:

1. Set up the Flutter Web project.
2. Set up Firebase and Firestore.
3. Create the simple MVVM folder structure.
4. Create `TaskModel`.
5. Create `TaskRepository` for Firestore access.
6. Create `TaskProvider` as the ViewModel.
7. Register Provider at the app root.
8. Create `TaskListPage`.
9. Create `TaskFormPage`.
10. Add status filtering.
11. Add loading, empty, and error states.
12. Refactor smaller UI pieces into `widgets/`.

This order starts from structure and data flow before UI complexity. It keeps the app concrete because every layer is immediately used by the task feature.

## Testing Scope

Testing is introduced lightly in this study case.

Recommended verification:

- Manual test checklist for CRUD behavior.
- Repository behavior explanation.
- Provider state transition explanation.

Full automated tests are intentionally out of scope for the first Provider + Firebase case. They can be introduced in a later iteration after students understand the architecture.

## Final Decision

Use **Simple Task Tracker** with **feature-first MVVM**:

```text
features/tasks/models
features/tasks/repositories
features/tasks/providers
features/tasks/views
features/tasks/widgets
```

Use `TaskProvider` instead of `TaskViewModel` in naming, because the learning goal is Provider. In the architecture explanation, state clearly that `TaskProvider` plays the ViewModel role.
