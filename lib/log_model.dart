// lib/models/log_model.dart

// Enum for the different types of logs
enum LogType { feeding, sleep, diaper, growth, pumping }

/// Data model for a single tracking entry in Kinli.
class LogEntry {
  final String id;
  final LogType type;
  final DateTime timestamp;
  final String? userId; // Used for Firestore pathing if needed
  final Map<String, dynamic> data;

  LogEntry({
    required this.id,
    required this.type,
    required this.timestamp,
    this.userId,
    required this.data,
  });

  /// Factory constructor to create a LogEntry from a Firestore document map.
  factory LogEntry.fromFirestore(Map<String, dynamic> doc) {
    return LogEntry(
      id: doc['id'] as String,
      // Safely convert string back to enum
      type: LogType.values.byName(doc['type'] as String),
      // Convert timestamp (milliseconds since epoch) back to DateTime
      timestamp: DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int),
      userId: doc['userId'] as String?,
      data: doc['data'] as Map<String, dynamic>,
    );
  }

  /// Converts the LogEntry object to a map suitable for Firestore storage.
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'type': type.name, // Store enum as string
      'timestamp': timestamp.millisecondsSinceEpoch,
      'userId': userId,
      'data': data,
      // 'createdAt' FieldValue.serverTimestamp() will be added in the service layer
    };
  }
}