import 'package:flutter/material.dart';
import 'package:shopping/helpers/dbhelper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DbHelper();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Shopping List'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  dbHelper.testDb();
                },
                child: Text("Insert Items!"),
              ),
              ElevatedButton(
                onPressed: () {
                  dbHelper.emptyTestDb();
                },
                child: Text("Delete All Items"),
              ),
              ElevatedButton(
                onPressed: () {
                  dbHelper.readAllLists();
                },
                child: Text("Read List!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
