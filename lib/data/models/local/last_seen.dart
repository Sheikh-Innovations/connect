import 'package:hive/hive.dart';

part 'last_seen.g.dart'; // This is for Hive type adapter code generation

@HiveType(typeId: 2)
class SeenMessage extends HiveObject {
  @HiveField(0)
  String senderId;

  @HiveField(1)
  DateTime seenAt;

  SeenMessage({required this.senderId, required this.seenAt});
}
