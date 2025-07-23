import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import 'task_provider.dart';
import 'task_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void _showTaskDialog(BuildContext context, {Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.description ?? '');
    DateTime? dueDate = task?.dueDate;
    String status = task?.status ?? 'pending';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(task == null ? 'Create Task' : 'Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ListTile(
                title: Text(dueDate == null
                    ? 'Pick Due Date'
                    : 'Due: ${dueDate?.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDate = picked;
                  }
                },
              ),
              DropdownButton<String>(
                value: status,
                items: ['pending', 'done']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) status = val;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<TaskProvider>(context, listen: false);
              if (task == null) {
                provider.addTask(Task(
                  title: titleController.text,
                  description: descController.text,
                  dueDate: dueDate ?? DateTime.now(),
                  status: status,
                ));
              } else {
                provider.updateTask(task.copyWith(
                  title: titleController.text,
                  description: descController.text,
                  dueDate: dueDate ?? DateTime.now(),
                  status: status,
                ));
              }
              Navigator.pop(ctx);
            },
            child: Text(task == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          final tasks = provider.tasks;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              final t = tasks[i];
              return ListTile(
                title: Text(t.title),
                subtitle: Text('${t.description}\nDue: ${t.dueDate.toLocal().toString().split(' ')[0]}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showTaskDialog(context, task: t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => Provider.of<TaskProvider>(context, listen: false).deleteTask(t.id!),
                    ),
                  ],
                ),
                leading: Checkbox(
                  value: t.status == 'done',
                  onChanged: (val) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .updateTask(t.copyWith(status: val! ? 'done' : 'pending'));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
