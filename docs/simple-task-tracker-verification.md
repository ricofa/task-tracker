# Simple Task Tracker Verification Checklist

## Static Checks

- [ ] `rtk flutter analyze` passes.
- [ ] `rtk flutter test` passes.
- [ ] No file under `lib/features/tasks/views/` imports `cloud_firestore`.
- [ ] No file under `lib/features/tasks/widgets/` imports `cloud_firestore`.
- [ ] Firestore access is isolated in `lib/features/tasks/repositories/task_repository.dart`.
- [ ] `TaskProvider` is registered above `MaterialApp` or above the page tree that needs it.

## Manual Browser Checks

- [ ] Run the app with `rtk flutter run -d chrome`.
- [ ] Empty state appears when Firestore has no tasks.
- [ ] Add task with title, description, status, priority, and optional due date.
- [ ] Added task appears in the list after submit.
- [ ] Edit task title and status.
- [ ] Edited task appears in the list after submit.
- [ ] Change status directly from `TaskCard`.
- [ ] Filter by `todo`, `doing`, and `done`.
- [ ] Clear filter with `All`.
- [ ] Delete a task.
- [ ] Deleted task disappears from the list.

## Teaching Checks

- [ ] Ask interns which file owns Firebase communication. Expected answer: `TaskRepository`.
- [ ] Ask interns which file owns loading and error state. Expected answer: `TaskProvider`.
- [ ] Ask interns why views should not import Firebase. Expected answer: View should only render UI and call Provider methods.
- [ ] Ask interns why `providers/` is still MVVM. Expected answer: `TaskProvider` acts as the ViewModel.
