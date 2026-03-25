import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/voice_provider.dart';
import '../../utils/theme.dart';

class VoiceIndicator extends ConsumerWidget {
  final String currentText;

  const VoiceIndicator({super.key, required this.currentText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black54.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.mic, color: AppTheme.primary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                'Listening...',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                currentText.isEmpty ? 'Speak your task now...' : '"$currentText"',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppTheme.textDim,
                  fontStyle: currentText.isEmpty ? FontStyle.normal : FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              // THE NEW STOP BUTTON ON THE CARD
              ElevatedButton.icon(
                onPressed: () => ref.read(voiceProvider.notifier).stopAndProcess(),
                icon: const Icon(LucideIcons.stopCircle, size: 20),
                label: const Text('STOP & SAVE TASK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
