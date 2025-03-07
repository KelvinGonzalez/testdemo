import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: String.fromEnvironment("API_KEY"),
          projectId: String.fromEnvironment("PROJECT_ID"),
          messagingSenderId: String.fromEnvironment("MESSAGING_SENDER_ID"),
          appId: String.fromEnvironment("APP_ID")));
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _count = 0;

  @override
  void initState() {
    super.initState();

    final db = FirebaseFirestore.instance;
    final collection = db.collection("Documents");
    final reference = collection.doc("Count");
    reference.snapshots().listen((data) {
      setState(() {
        _count = data.data()?["count"] ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text(
          "My App's Title",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red,
          ),
        ),
      ),
      body: Center(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Score so far..."),
          ),
          Text(_count.toString()),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: onClicked,
        child: const Icon(Icons.add),
      ),
    );
  }

  void onClicked() {
    final reference =
        FirebaseFirestore.instance.collection("Documents").doc("Count");
    reference.update({"count": FieldValue.increment(1)});
  }
}
