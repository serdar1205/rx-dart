import 'dart:convert';
import 'dart:io';

import 'package:rx_dart/models/animal.dart';
import 'package:rx_dart/models/person.dart';
import 'package:rx_dart/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    ///search in the cache
    final cachedResults = _extractThingsUsingSearchTerm(term);
    if (cachedResults != null) {
      return cachedResults;
    }
    //if we don't have cached data then search from api

    final persons =
        await _getJson('https://person.wiremockapi.cloud/api/persons')
            .then((json) => json.map((e) => Person.fromJson(e)));
    _persons = persons.toList();

    final animals =
        await _getJson('https://person.wiremockapi.cloud/api/animals')
            .then((json) => json.map((e) => Animal.fromJson(e)));
    _animals = animals.toList();
    return _extractThingsUsingSearchTerm(term) ?? [];
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((request) => request.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString));

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPerson = _persons;
    if (cachedAnimals != null && cachedPerson != null) {
      List<Thing> result = [];
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }
      // persons
      for (final person in cachedPerson) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    }
    return null;
  }
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}//
