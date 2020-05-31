import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:heady_ecommerce/models/ProductResponse.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/auth.dart';
import 'package:heady_ecommerce/screens/search.dart';
import 'package:heady_ecommerce/utils/constants.dart';
import 'package:heady_ecommerce/utils/drawer_homescreen.dart';
import 'package:heady_ecommerce/widgets/category_box.dart';
import 'package:heady_ecommerce/widgets/shopping_cart_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Size _deviceSize;
  Map<dynamic, dynamic> responseBody;
  bool _isCategoryLoading = true;
  bool _isDealsLoading = true;
  int favCount;
  ProductResponse _productResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCategories();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;

    Widget bannerCarousel = CarouselSlider(
      items: [bannerCards(0)],
      autoPlay: true,
      enlargeCenterPage: true,
    );
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'heady',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontFamily: 'HolyFat', fontSize: 40),
                  )),
              actions: <Widget>[
                shoppingCartIconButton(),
              ],
              bottom: PreferredSize(
                preferredSize: Size(_deviceSize.width, 70),
                child: searchBar(),
              ),
            ),
            drawer: HomeDrawer(),
            body: Container(
              color: Colors.white,
              child: CustomScrollView(slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        color: Colors.grey.withOpacity(0.1), child: bannerCarousel)
                  ]),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 1.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      width: _deviceSize.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.category,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text('Shop By Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontFamily: fontFamily
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                _isCategoryLoading
                    ? SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: _deviceSize.height * 0.5,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepOrange,
                        ),
                      )
                    ]))
                    : _productResponse.categories.length > 0
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return categoryBox(
                                  index, context, _deviceSize, _productResponse.categories, _productResponse.rankings);
                            }, childCount: _productResponse.categories.length + 1),
                      )
                    : SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      width: _deviceSize.width,
                      color: Colors.white,
                      child: Center(
                        child: Text('No items present'),
                      ),
                    ),
                  ]),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    height: 20.0,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 1.0,
                  ),
                ),

                /*SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        width: _deviceSize.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.local_offer,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('Shop By Ranking',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: fontFamily)),
                            ],
                          ),
                        ))
                  ]),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    height: 20.0,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 1.0,
                  ),
                ),*/
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        width: _deviceSize.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.local_offer,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('Today\'s Deals',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: fontFamily)),
                            ],
                          ),
                        ))
                  ]),
                ),
                _isDealsLoading
                    ? SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: _deviceSize.height * 0.25,
                        alignment: Alignment.center,
                        width: _deviceSize.width,
                        color: Colors.white,
                        child: Center(
                          child: Text('Coming Soon...', style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                      )
                    ]))
                    : SliverToBoxAdapter(
                  child: Container(
                    height: 355,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
              ]),
            ),
            bottomNavigationBar:
            !model.isAuthenticated ? bottomNavigationBar() : null,
          );
        });
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        MaterialPageRoute route =
        MaterialPageRoute(builder: (context) => Authentication(index));

        Navigator.push(context, route);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: Colors.deepOrange),
          title: Text('SIGN IN',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 15,
              fontWeight: FontWeight.w600
            )
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: Colors.deepOrange,
          ),
          title: Text('CREATE ACCOUNT',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 15,
              fontWeight: FontWeight.w600
            )
          )
        ),
      ],
    );
  }

  Widget bannerCards(int index) {
    return Container(
      width: _deviceSize.width * 0.8,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 2,
        margin: EdgeInsets.symmetric(
            vertical: _deviceSize.height * 0.05,
            horizontal: _deviceSize.width * 0.02),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Image.asset(
              'images/placeholders/slider2.jpg',
              fit: BoxFit.fill,
            )),
      ),
    );
  }

  getCategories() async {
    http.Response response = await http.get(Settings.SERVER_URL);
    if(response!=null && response.statusCode==200){
      print(response.body.toString());
      setState(() {
        _productResponse = ProductResponse.fromJson(json.decode(response.body.toString())as Map<String, dynamic>);
      });
    }
    setState(() {
      _isCategoryLoading = false;
    });
  }

  Widget searchBar() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return GestureDetector(
              onTap: () {
                MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => ProductSearch());
                Navigator.of(context).push(route);
              },
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  width: _deviceSize.width,
                  height: 55,
                  margin: EdgeInsets.all(010),
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text(
                      'Search',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                model.isLoading ? LinearProgressIndicator() : Container()
              ]));
        });
  }
}
