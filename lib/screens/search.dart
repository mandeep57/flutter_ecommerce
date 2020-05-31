
import 'package:flutter/material.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductSearch extends StatefulWidget {
  final String slug;
  ProductSearch({this.slug});

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  String txtStr = '';
  Size _deviceSize;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext mainContext) {
    _deviceSize = MediaQuery.of(mainContext).size;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 1.0,
                backgroundColor: Colors.white,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        txtStr = value;
                      });
                    },
                    onSubmitted: (value) {
                      print("ENTER PRESSED ------> $value");
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        labelStyle:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                  ),
                ),
                actions: <Widget>[
                  Visibility(
                    visible: txtStr != null && txtStr.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          txtStr = '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 90.0),
                  ),
                  Visibility(
                      visible: model.isLoading,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                      )),
                  // )
                ],
              ));
        });
  }
}
