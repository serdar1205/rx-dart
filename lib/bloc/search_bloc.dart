import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }
  factory SearchBloc({
    required Api api,
  }) {
    final textChanges = BehaviorSubject<String>();

    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((value) {
      if (value.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(value))
            .delay(const Duration(seconds: 2))
            .map((event) => event.isEmpty
                ? const SearchResultEmpty()
                : SearchResultWithResults(event))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith(
                (error, stackTrace) => SearchResultHasError(error));
      }
    });

    return SearchBloc._(search: textChanges.sink, results: results);
  }

  const SearchBloc._({required this.search, required this.results});
}
/*
* switchMap<SearchResult?>(): Maps each search query to a stream of search results.
* If a new search query arrives while a previous search is still in progress,
* it cancels the previous search and starts a new one with the latest query.**/
