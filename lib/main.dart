import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    streamOfStrings = subject.switchMap((dateTime) => Stream.periodic(
        const Duration(seconds: 1),
        (count) => 'Stream count = $count, dateTime = $dateTime'));
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      body: Column(
        children: [

          StreamBuilder<String>(
              stream: streamOfStrings,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  final string = snapshot.requireData;
                  return Text(string);
                }  else{
                  return const Text('Press the button');
                }
              }),

          TextButton(onPressed: (){
            subject.add(DateTime.now());
          }, child: const Text('Start the stream'))
        ],
      ),
    );
  }
}
