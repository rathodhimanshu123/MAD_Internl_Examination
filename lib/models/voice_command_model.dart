enum CommandType { add, update, delete, check, uncheck }

class VoiceCommandModel {
  final String id;
  final CommandType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool processed;

  VoiceCommandModel({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    this.processed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'data': data.toString(), // or JSON if complex
      'timestamp': timestamp.toIso8601String(),
      'processed': processed ? 1 : 0,
    };
  }

  // Not adding factory for now as it's secondary to the core app logic
}
