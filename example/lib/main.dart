import 'package:flutter/material.dart';
import 'package:mat_comp/mat_comp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final items = List<_ItemObject>.generate(
    10,
    (index) => _ItemObject(id: index.toString(), name: 'item $index'),
  );

  List<String> onChanged = [];
  List<String> onSaved = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mat Comp'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _formKey.currentState.save(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonMultiple<_ItemObject, String>(
                choices: items,
                displayLabelWith: (i) => i.name,
                getValueWith: (i) => i.id,
                placeholder: 'select items',
                compareWith: (choice, value) => choice.id == value,
                onChanged: (values) => setState(() => onChanged = values),
                onSaved: (values) => setState(() => onSaved = values),
                initValues: ['1'],
              ),
              SizedBox(height: 20.0),
              Text('onChanged: $onChanged'),
              Text('onSaved: $onSaved'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemObject {
  final String id;
  final String name;

  _ItemObject({@required this.id, @required this.name});
}
