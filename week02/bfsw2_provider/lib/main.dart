import 'package:bfsw2_provider/model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController prController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItems,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addItems() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        width: double.infinity,
        color: Colors.amberAccent,
        child: Expanded(
          child: ListView(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
              ),
              TextField(
                controller: desController,
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
              ),
              TextField(
                controller: desController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Price'),
                ),
              ),
              ElevatedButton(
                onPressed: saveItems,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveItems() {
    Product pro = Product(1, 'name', 'description', 0);
  }
}
