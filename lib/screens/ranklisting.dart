import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/models/ProductResponse.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/search.dart';
import 'package:heady_ecommerce/utils/drawer_homescreen.dart';
import 'package:heady_ecommerce/widgets/shopping_cart_button.dart';
import 'package:scoped_model/scoped_model.dart';

class RankList extends StatefulWidget {
  List<Rankings> rankings;

  RankList(this.rankings);

  @override
  _RankListState createState() => _RankListState();
}

class _RankListState extends State<RankList> {
  Size _deviceSize;
  String _rankType = '';
  String _heading = 'By Rank';
  bool hasMore = false;
  bool _isSelected = false;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return WillPopScope(
              onWillPop: () => _canLeave(),
              child: Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    elevation: 0.0,
                    title: Text('Products'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => ProductSearch());
                          Navigator.of(context).push(route);
                        },
                      ),
                      shoppingCartIconButton()
                    ],
                  ),
                  drawer: HomeDrawer(),
                  //endDrawer: filterDrawer(),
                  body: Stack(
                    children: <Widget>[
                      Scrollbar(
                          child: _isLoading
                              ? Container(
                            height: _deviceSize.height,
                          )
                              : !_isSelected
                              ? Padding(
                              child: ListView.builder(
                                  itemCount: widget.rankings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        color: Colors.white,
                                        child: Column(children: [
                                          GestureDetector(
                                              onTap: () {
                                                _rankType = widget.rankings[index].ranking;
                                                 Fluttertoast.showToast(
                                                  msg: "Coming Soon...",
                                                  toastLength: Toast.LENGTH_LONG,
                                                );
                                              },
                                              child: Container(
                                                  color: Colors.white,
                                                  width: _deviceSize.width,
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  margin:
                                                  EdgeInsets.all(10),
                                                  padding:
                                                  EdgeInsets.all(10),
                                                  child: Text(
                                                    widget.rankings[index].ranking,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ))),
                                          Divider()
                                        ]));
                                  }),
                              padding: EdgeInsets.only(top: 59.0))
                              : Theme(
                            data: ThemeData(primarySwatch: Colors.green),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 90.0),
                            ),
                          )
                      ),

                      Container(
                          color: Colors.deepOrange,
                          height: 60.0,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelected = false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 70,
                                        bottom: 20,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _heading,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: _isSelected
                                                ? FontWeight.w200
                                                : FontWeight.bold),
                                      ),
                                    )),
                                _isSelected
                                    ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    ' > ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200),
                                  ),
                                )
                                    : Container(),
                                _isSelected
                                    ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text("",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                                    : Container()
                              ],
                            ),
                            _isLoading || model.isLoading
                                ? Padding(
                                child: LinearProgressIndicator(),
                                padding: EdgeInsets.only(top: 10.0))
                                : Container()
                          ])),
                      /*_isSelected
                          ? Container(
                        padding: EdgeInsets.only(right: 20.0, top: 30.0),
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      )
                          : Container(),*/
                    ],
                  )));
        });
  }

  Future<bool> _canLeave() {
    if (!_isSelected) {
      return Future<bool>.value(true);
    } else {
      setState(() {
        _isSelected = false;
      });
      return Future<bool>.value(false);
    }
  }
}
