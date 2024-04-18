import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Emoji extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String emojiPath;

  Emoji({required this.name, required this.emojiPath});
}
