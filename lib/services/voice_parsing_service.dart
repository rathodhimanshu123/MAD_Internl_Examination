import '../models/voice_command_model.dart';
import 'package:uuid/uuid.dart';

class VoiceParsingService {
  static VoiceCommandModel? parse(String text) {
    final lowerText = text.toLowerCase();
    final uuid = const Uuid().v4();

    // Handle "add X", "create X", "new task X", "put X on my list"
    final addMatch = RegExp(r'(?:add|create|new|put|remind me to)\s*(.*)', caseSensitive: false).firstMatch(lowerText);
    if (addMatch != null) {
      final title = addMatch.group(1)?.trim() ?? '';
      if (title.isNotEmpty) {
        return VoiceCommandModel(
          id: uuid,
          type: CommandType.add,
          data: {'title': title},
          timestamp: DateTime.now(),
        );
      }
    }

    // Handle "delete X", "remove X"
    final deleteMatch = RegExp(r'(?:delete|remove)\s*(.*)', caseSensitive: false).firstMatch(lowerText);
    if (deleteMatch != null) {
      final title = deleteMatch.group(1)?.trim() ?? '';
      return VoiceCommandModel(
        id: uuid,
        type: CommandType.delete,
        data: {'title': title},
        timestamp: DateTime.now(),
      );
    }

    // Handle "complete X", "check X", "finish X"
    final checkMatch = RegExp(r'(?:complete|check|finish|done with)\s*(.*)', caseSensitive: false).firstMatch(lowerText);
    if (checkMatch != null) {
      final title = checkMatch.group(1)?.trim() ?? '';
      return VoiceCommandModel(
        id: uuid,
        type: CommandType.check,
        data: {'title': title},
        timestamp: DateTime.now(),
      );
    }
    // If no keywords found, but text is not empty, assume "Add" (Leniency)
    if (text.trim().isNotEmpty) {
      return VoiceCommandModel(
        id: uuid,
        type: CommandType.add,
        data: {'title': text.trim()},
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}
