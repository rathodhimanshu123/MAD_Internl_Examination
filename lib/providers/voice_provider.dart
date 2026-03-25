import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/tts_service.dart';
import '../services/voice_parsing_service.dart';
import '../models/voice_command_model.dart';
import 'task_provider.dart';

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  return VoiceNotifier(ref);
});

class VoiceState {
  final bool isListening;
  final String currentText;
  final String lastError;

  VoiceState({
    required this.isListening,
    required this.currentText,
    this.lastError = '',
  });

  VoiceState copyWith({bool? isListening, String? currentText, String? lastError}) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      currentText: currentText ?? this.currentText,
      lastError: lastError ?? this.lastError,
    );
  }
}

class VoiceNotifier extends StateNotifier<VoiceState> {
  final Ref _ref;
  final SpeechToText _speech = SpeechToText();
  final TTSService _tts = TTSService();

  VoiceNotifier(this._ref) : super(VoiceState(isListening: false, currentText: 'Tap the mic to start speaking'));

  Future<void> startListening() async {
    if (state.isListening) return;
    
    bool available = await _speech.initialize(
      onError: (errorNotification) {
        state = state.copyWith(isListening: false, lastError: errorNotification.errorMsg);
      },
    );

    if (available) {
      state = state.copyWith(isListening: true, currentText: 'Listening...');
      await _speech.listen(
        onResult: (result) {
          state = state.copyWith(currentText: result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 10),
        listenMode: ListenMode.dictation,
      );
    }
  }

  Future<void> stopAndProcess() async {
    final textToProcess = state.currentText;
    await _speech.stop();
    state = state.copyWith(isListening: false);
    
    if (textToProcess.trim().isNotEmpty) {
      _processCommand(textToProcess);
    }
  }

  void stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);
  }

  void _processCommand(String text) {
    final command = VoiceParsingService.parse(text);
    if (command == null) {
      _tts.speak("Sorry, I didn't understand.");
      return;
    }

    switch (command.type) {
      case CommandType.add:
        final title = command.data['title'] as String;
        _ref.read(taskListProvider.notifier).addTask(title);
        _tts.speak("Added.");
        break;
      case CommandType.delete:
        final title = command.data['title'] as String;
        _ref.read(taskListProvider.notifier).deleteTaskByTitle(title);
        _tts.speak("Deleted.");
        break;
      case CommandType.check:
        final title = command.data['title'] as String;
        _ref.read(taskListProvider.notifier).toggleTaskByTitle(title);
        _tts.speak("Done.");
        break;
      default:
        break;
    }
  }
}
