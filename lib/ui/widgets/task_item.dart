import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/theme.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class TaskItem extends ConsumerWidget {
  final TaskModel task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => ref.read(taskListProvider.notifier).toggleTask(task.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? AppTheme.primary : AppTheme.textDim,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    task.isCompleted ? LucideIcons.checkCircle2 : null,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        'Last updated today',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppTheme.textDim,
                        ),
                      ),
                    ],
                  ),
                ),
                // EDIT BUTTON
                IconButton(
                  icon: const Icon(LucideIcons.pencil, size: 18, color: AppTheme.textDim),
                  onPressed: () => _showEditDialog(context, ref),
                ),
                // DELETE BUTTON
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 20, color: Colors.redAccent),
                  onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Text('Edit Task', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Update your task',
            labelStyle: GoogleFonts.outfit(color: AppTheme.textDim),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: GoogleFonts.outfit(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(taskListProvider.notifier).updateTaskTitle(task.id, controller.text.trim());
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('SAVE', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
