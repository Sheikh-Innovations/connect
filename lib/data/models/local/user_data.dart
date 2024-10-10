import 'package:hive/hive.dart';

part 'user_data.g.dart'; // This part is required for Hive type adapter generation

@HiveType(typeId: 0) // Assign a unique ID for this data type
class UserHiveData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String number;

  @HiveField(3)
  final String? avater; // Note: Use 'avater' to match your JSON structure

  @HiveField(4)
  final String fcmToken;

  @HiveField(5)
  final String token;

 UserHiveData({
    required this.id,
     this.name,
    required this.number,
    this.avater,
    required this.fcmToken,
    required this.token,
  });
}
//flutter packages pub run build_runner build