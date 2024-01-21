import 'package:hive/hive.dart';

import 'todo_hive.dart';

class TodoAdapter extends TypeAdapter<TodoHive> {
  @override
  TodoHive read(BinaryReader reader) {
    final id = reader.read() as String;
    final name = reader.read() as String;
    final description = reader.read() as String;
    final date = reader.read() as String;
    final isDone = reader.read() as bool;

    return TodoHive(
      id: id,
      name: name,
      description: description,
      date: DateTime.parse(date),
      isDone: isDone,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, TodoHive obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.date.toString());
    writer.write(obj.isDone);
  }
}
