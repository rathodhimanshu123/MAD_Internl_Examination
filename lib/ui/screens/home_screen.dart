import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/theme.dart';
import '../../providers/task_provider.dart';
import '../../providers/voice_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/voice_indicator.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final voiceState = ref.watch(voiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text('TaskFlow Solutions', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut), 
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          IconButton(icon: const Icon(LucideIcons.user), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Purple Header Banner mimicking the screenshot
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: AppTheme.purpleBanner,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rathod Himanshu M',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TaskFlow Admin • Joined March 21, 2026',
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Manual Task Entry mimicking "Edit Profile" button style but as a field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: GoogleFonts.outfit(color: AppTheme.textMain),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add new task...',
                            hintStyle: GoogleFonts.outfit(color: AppTheme.textDim),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.plusCircle, color: AppTheme.primary),
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            ref.read(taskListProvider.notifier).addTask(_textController.text);
                            _textController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Task list Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(LucideIcons.listTodo, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'YOUR RECENT TASKS',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textDim,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskItem(task: tasks[index]),
                    );
                  },
                ),
              ),
            ],
          ),
          if (voiceState.isListening)
            VoiceIndicator(currentText: voiceState.currentText),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: voiceState.isListening ? Colors.red : AppTheme.primary,
        onPressed: () {
          if (voiceState.isListening) {
            ref.read(voiceProvider.notifier).stopAndProcess();
          } else {
            ref.read(voiceProvider.notifier).startListening();
          }
        },
        icon: Icon(
          voiceState.isListening ? LucideIcons.stopCircle : LucideIcons.mic, 
          color: Colors.white
        ),
        label: Text(
          voiceState.isListening ? 'STOP & SAVE' : 'VOICE ADD', 
          style: GoogleFonts.outfit(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
