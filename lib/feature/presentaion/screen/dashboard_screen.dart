
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/entity.dart';
import '../bloc/mcqs_bloc.dart';
import '../bloc/mcqs_event.dart';
import '../bloc/mcqs_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MCQBloc>().add(LoadAllMCQsEvent());
  }

  void _showAddEditDialog({MCQ? mcq}) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddEditMCQDialog(
        mcq: mcq,
        onSave: (newMcq) {
          if (mcq == null) {
            context.read<MCQBloc>().add(AddMCQEvent(newMcq));
          } else {
            context.read<MCQBloc>().add(UpdateMCQEvent(newMcq));
          }
        },
      ),
    );
  }

  void _deleteMCQ(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete MCQ'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MCQBloc>().add(DeleteMCQEvent(id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Dashboard'),
        centerTitle: true,
      ),
      body: BlocConsumer<MCQBloc, MCQState>(
        listener: (context, state) {
          if (state is MCQOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MCQError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MCQLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MCQsLoaded) {
            if (state.mcqs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.quiz, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No MCQs yet',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add First MCQ'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.mcqs.length,
              itemBuilder: (context, index) {
                final mcq = state.mcqs[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      mcq.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                        'Category: ${mcq.category} | Difficulty: ${_difficultyText(mcq.difficultyLevel)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(mcq: mcq),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMCQ(mcq.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _difficultyText(int level) {
    switch (level) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }
}

// ----------------- Add/Edit MCQ Dialog -----------------
class _AddEditMCQDialog extends StatefulWidget {
  final MCQ? mcq;
  final Function(MCQ) onSave;

  const _AddEditMCQDialog({this.mcq, required this.onSave});

  @override
  State<_AddEditMCQDialog> createState() => _AddEditMCQDialogState();
}

class _AddEditMCQDialogState extends State<_AddEditMCQDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _categoryController;
  late TextEditingController _explanationController;
  late List<TextEditingController> _optionControllers;
  int _correctAnswerIndex = 0;
  int _difficultyLevel = 1;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.mcq?.question ?? '');
    _categoryController =
        TextEditingController(text: widget.mcq?.category ?? '');
    _explanationController =
        TextEditingController(text: widget.mcq?.explanation ?? '');
    _optionControllers = List.generate(
      4,
          (index) => TextEditingController(
        text: widget.mcq != null && index < widget.mcq!.options.length
            ? widget.mcq!.options[index]
            : '',
      ),
    );
    if (widget.mcq != null) {
      _correctAnswerIndex = widget.mcq!.correctAnswerIndex;
      _difficultyLevel = widget.mcq!.difficultyLevel;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _categoryController.dispose();
    _explanationController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final mcq = MCQ(
        id: widget.mcq?.id ?? const Uuid().v4(),
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        correctAnswerIndex: _correctAnswerIndex,
        explanation:
        _explanationController.text.isEmpty ? null : _explanationController.text,
        category: _categoryController.text,
        difficultyLevel: _difficultyLevel,
        createdAt: widget.mcq?.createdAt ?? DateTime.now(),
      );
      widget.onSave(mcq);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.mcq == null ? 'Add MCQ' : 'Edit MCQ',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              _correctAnswerIndex = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _optionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Option ${String.fromCharCode(65 + index)}',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _explanationController,
                  decoration: const InputDecoration(
                    labelText: 'Explanation (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _difficultyLevel,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty Level',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Easy')),
                    DropdownMenuItem(value: 2, child: Text('Medium')),
                    DropdownMenuItem(value: 3, child: Text('Hard')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _difficultyLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _save, child: const Text('Save')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
