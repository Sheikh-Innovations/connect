class EditRemoveRspnse {
  String senderId; // ID of the sender
  String recipientId; // ID of the recipient
  String messageId; // Unique identifier for the message
  String eventType; // Type of event (e.g., "edit", "delete")
  String newContent; // New content of the message if edited
  DateTime timestamp; // Timestamp of the message

  // Constructor
  EditRemoveRspnse({
    required this.senderId,
    required this.recipientId,
    required this.messageId,
    required this.eventType,
    required this.newContent,
    required this.timestamp,
  });

  // Factory method to create an instance from a map
  factory EditRemoveRspnse.fromMap(Map<String, dynamic> map) {
    return EditRemoveRspnse(
      senderId: map['senderId'],
      recipientId: map['recipientId'],
      messageId: map['messageId'],
      eventType: map['eventType'],
      newContent: map['newContent'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
