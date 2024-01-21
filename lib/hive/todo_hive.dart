import 'package:hive/hive.dart';

class TodoHive  extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime? date;
  @HiveField(4)
  bool isDone;

  TodoHive({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.isDone,
  });
}
