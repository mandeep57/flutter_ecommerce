import 'package:flutter/material.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/home.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  final MainModel _model = MainModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Heady App',
        initialRoute: '/home',
        routes: {
          '/home' : (context) => HomeScreen()
        },
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.white,
        ),
        home: HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
