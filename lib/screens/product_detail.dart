import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/models/ProductResponse.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/auth.dart';
import 'package:heady_ecommerce/screens/search.dart';
import 'package:heady_ecommerce/utils/constants.dart';
import 'package:heady_ecommerce/widgets/rating_bar.dart';
import 'package:heady_ecommerce/widgets/shopping_cart_button.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Products product;
  ProductDetailScreen(this.product);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFavorite = false;
  bool _isUserLogedIn = false;
  Products selectedProduct;
  String selectedColor;
  int selectedSize;
  Size _deviceSize;
  TabController _tabController;
  int quantity = 1;


  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    selectedProduct = widget.product;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text('Item Details'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductSearch());
                      Navigator.of(context).push(route);
                    },
                  ),
                  shoppingCartIconButton()
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Column(
                    children: [
                      TabBar(
                        indicatorWeight: 4.0,
                        controller: _tabController,
                        tabs: <Widget>[
                          Tab(
                            text: 'HIGHLIGHTS',
                          ),
                          Tab(
                            text: 'REVIEWS',
                          )
                        ],
                      ),
                      model.isLoading ? LinearProgressIndicator() : Container()
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[highlightsTab(), reviewsTab()],
              ),
              floatingActionButton: addToCartFAB());
        });
  }

  Widget reviewsTab() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          writeReview(),
          Container(
            height: 400,
            alignment: Alignment.center,
            child: Text("No Reviews found"),
          )
        ],
      )
    );
  }

  Widget writeReview() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40.0,
              width: 335,
              child: GestureDetector(
                onTap: () {
                  if (model.isAuthenticated) {
                   // navigate to write review screen
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Please Login to write review.',
                      ),
                      action: SnackBarAction(
                        label: 'LOGIN',
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(builder: (context) => Authentication(0));
                          Navigator.push(context, route);
                        },
                      ),
                    ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepOrange,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "WRITE A REVIEW",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]
        );
      }
    );
  }

  Widget highlightsTab() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 300,
                                width: 220,
                                child: FadeInImage(
                                  image:AssetImage('images/placeholders/no-product-image.png'),
                                  placeholder: AssetImage('images/placeholders/no-product-image.png'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          padding: EdgeInsets.only(top: 40, right: 15.0),
                          alignment: Alignment.topRight,
                          icon: Icon(Icons.favorite),
                          color: _isFavorite ? Colors.orange : Colors.grey,
                          onPressed: () async {
                            if (!_isFavorite) {
                              if (!_isUserLogedIn) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    'Please Login to add to Favorites',
                                  ),
                                  action: SnackBarAction(
                                    label: 'LOGIN',
                                    onPressed: () {
                                      MaterialPageRoute route = MaterialPageRoute(
                                          builder: (context) => Authentication(0));
                                      Navigator.push(context, route);
                                    },
                                  ),
                                ));
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    'Adding to Favorites, please wait.',
                                  ),
                                  duration: Duration(seconds: 1),
                                ));
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Removing from Favorites, please wait.',
                                ),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: _deviceSize.width,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'By ${selectedProduct.name.split(' ')[0]}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green,
                                  fontFamily: fontFamily),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              ratingBar(selectedProduct.avgRating, 20),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text("220")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      selectedProduct.name,
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  widget.product.variants!=null &&
                      selectedProduct.variants.length > 0
                      ? variantColorDropDown()
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),

                  widget.product.variants!=null &&
                      selectedProduct.variants.length > 0
                      ? variantSizeDropDown()
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Quantity ',
                      style: TextStyle(fontSize: 14, fontFamily: fontFamily),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  quantityRow(model, selectedProduct),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Price ',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          CURRENCY_SYMBOL+""+selectedProduct.price,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  addToCartFlatButton(),
                  SizedBox(
                    height: 12.0,
                  ),
                  buyNowFlatButton(),

                  Divider(),

                  SizedBox(
                    height: 2,
                  ),

                  Container(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      alignment: Alignment.centerLeft,
                      child: Text("Description",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w600
                          )
                      )
                  ),

                  Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text("No Description Available", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w200))
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buyNowFlatButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            height: 45.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.deepOrange,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('BUY NOW',
                style: TextStyle(
                    color: Colors.deepOrange),
              ),
              onPressed:() {
                Fluttertoast.showToast(
                  msg: "Coming Soon...",
                  toastLength: Toast.LENGTH_LONG,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget addToCartFlatButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            height: 45.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(4),
              ),

              child: Text('ADD TO CART',  style: TextStyle(color: Colors.green)),
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Coming Soon...",
                  toastLength: Toast.LENGTH_LONG,
                );
              }
            ),
          ),
        );
      },
    );
  }

  Widget addToCartFAB() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
           onPressed: (){
             Fluttertoast.showToast(
               msg: "Coming Soon...",
               toastLength: Toast.LENGTH_LONG,
             );
           },
        );
      },
    );
  }

  Widget quantityRow(MainModel model, Products selectedProduct) {
    return Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    quantity = index;
                  });
                },
                child: Container(
                    width: 45,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: quantity == index
                              ? Colors.deepOrangeAccent
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    alignment: Alignment.center,
                    // margin: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                          color: quantity == index
                              ? Colors.deepOrangeAccent
                              : Colors.grey.shade300
                      ),
                    )),
              );
            }
          },
        ));
  }

  List<DropdownMenuItem<String>> getVariantColors() {
    List<DropdownMenuItem<String>> items = new List();
    List<String> colors = new List();

    widget.product.variants.forEach((variant) {
      if(!colors.toString().toLowerCase().contains(variant.color.toLowerCase())){
        colors.add(variant.color);
        items.add(DropdownMenuItem(
          value: variant.color,
          child: Text(
            variant.color,
            style: TextStyle(color: Colors.black),
          ),
        ));
      }
    });
    return items;
  }

  List<DropdownMenuItem<String>> getVariantSize() {
    List<DropdownMenuItem<String>> items = new List();
    List<int> sizes = new List();

    widget.product.variants.forEach((variant) {
      if(!sizes.contains(variant.size) && variant.color=='${selectedColor}'){
        sizes.add(variant.size);
        items.add(DropdownMenuItem(
          value: variant.size.toString(),
          child: Text(
            variant.size.toString(),
            style: TextStyle(color: Colors.black),
          ),
        ));
      }
    });
    return items;
  }

  Widget variantColorDropDown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: _deviceSize.width,
      height: 50,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        iconEnabledColor: Colors.black,
        items: getVariantColors(),
        value: selectedProduct.variants[0].color,
        onChanged: (value) {
          widget.product.variants.forEach((variant) {
            if (variant.color == value) {
              setState(() {
                selectedColor = variant.color;
                print('$selectedColor');
              });
            }
          });
        },
        hint: Text("Select Color")
      ),
    );
  }

  Widget variantSizeDropDown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: _deviceSize.width,
      height: 50,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        iconEnabledColor: Colors.black,
        items: getVariantSize(),
        value: selectedProduct.variants[0].size.toString(),
        onChanged: (value) {
          widget.product.variants.forEach((variant) {
            if (variant.size == value) {
              setState(() {
                selectedSize = variant.size;
                print('$selectedSize');
              });
            }
          });
        },
        hint: Text("Select Size")
      )
    );
  }
}
