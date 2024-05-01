import 'package:flutter/material.dart';
import 'package:rx_dart/bloc/api.dart';
import 'package:rx_dart/bloc/search_bloc.dart';
import 'package:rx_dart/views/search_result_view.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late final SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(api: Api());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your search term here...',
              ),
              onChanged: _bloc.search.add,
            ),
            const SizedBox(
              height: 10,
            ),
            SearchResultView(
              searchResult: _bloc.results,
            ),
          ],
        ),
      ),
    );
  }
}
