import 'package:connect/data/models/local/last_seen.dart';

class LasSeenEntry {
  final String senderId;
  DateTime seenAt; // The `seenAt` can be updated

  LasSeenEntry({
    required this.senderId,
    required this.seenAt,
  });

  // Factory method to create an instance from a Map
  factory LasSeenEntry.fromMap(Map<String, dynamic> map) {
    return LasSeenEntry(
      senderId: map['senderId'] as String,
      seenAt: DateTime.parse(map['seenAt'] as String),
    );
  }

  // Factory method to create an instance from a Map
  factory LasSeenEntry.fromSeenMessage(SeenMessage hive) {
    return LasSeenEntry(senderId: hive.senderId, seenAt: hive.seenAt);
  }

  // Convert the instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'seenAt': seenAt.toIso8601String(),
    };
  }

  SeenMessage toHiveData() {
    return SeenMessage(senderId: senderId, seenAt: seenAt);
  }

  // Method to update the seenAt time
  void updateSeenAt(DateTime newSeenAt) {
    seenAt = newSeenAt;
  }
}
