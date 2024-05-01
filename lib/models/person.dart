import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({
    required String name,
    required this.age,
  }) : super(name: name);

  @override
  String toString() {
    return 'Person{name:$name, age: $age}';
  }

  Person.fromJson(Map<String, dynamic> json)
      : age = json['age'] as int,
        super(name: json["name"] as String);

}
