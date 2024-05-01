import 'package:flutter/foundation.dart';
import 'package:rx_dart/models/thing.dart';

enum AnimalType { dog, cat, rabbit, unknown }

@immutable
class Animal extends Thing {
  final AnimalType type;

  const Animal({
    required String name,
    required this.type,
  }) : super(name: name);

  @override
  String toString() {
    return 'Animal{name:$name, type: $type}';
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    AnimalType animalType = AnimalType.unknown;
    switch ((json["type"] as String).toLowerCase().trim()) {
      case "rabbit":
        animalType = AnimalType.rabbit;
        break;
      case "dog":
        animalType = AnimalType.dog;
        break;
      case "cat":
        animalType = AnimalType.cat;
        break;
    }
    return Animal(name: json["name"], type: animalType);
  }
}
