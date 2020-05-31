import 'package:flutter/material.dart';
import 'package:heady_ecommerce/models/ProductResponse.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/search.dart';
import 'package:heady_ecommerce/utils/constants.dart';
import 'package:heady_ecommerce/utils/drawer_homescreen.dart';
import 'package:heady_ecommerce/widgets/product_container.dart';
import 'package:heady_ecommerce/widgets/shopping_cart_button.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoryListing extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int parentId;
  Categories categories;

  CategoryListing(this.categoryName, this.categoryId, this.parentId,this.categories);

  @override
  State<StatefulWidget> createState() {
    return _CategoryListingState();
  }
}

class _CategoryListingState extends State<CategoryListing> {
  Size _deviceSize;
  bool _isLoading = true;
  int level = 0;
  static const int PAGE_SIZE = 20;
  List<Products> productsByCategory = [];
  List<Widget> header = [];
  final int perPage = TWENTY;
  int currentPage = ONE;
  int subCatId = ZERO;
  int currentIndex = -1;
  int totalCount = 0;
  List<Widget> subCatList = [];
  final scrollController = ScrollController();
  bool hasMore = false, isFilterDataLoading = false;
  bool isChecked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // ADD THIS LINE
  Map<dynamic, dynamic> responseBody;
  String sortBy = '';
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItem;

  List filterItems = [
    "Most Viewed",
    "Most Ordered",
    "Most Shared",
    "A TO Z",
    "Z TO A"
  ];
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in filterItems) {
      items.add(new DropdownMenuItem(
          value: city,
          child: Text(
            city,
            // style: TextStyle(color: Colors.red),
          )));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    sortBy = '';
    _dropDownMenuItems = getDropDownMenuItems();
    _currentItem = _dropDownMenuItems[0].value;

    header.add(textField(widget.categoryName, FontWeight.w100, 0, Colors.white));

    if(widget.categories!=null && widget.categories.products.length>0){
      productsByCategory = widget.categories.products;
      loadProductsByCategory();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
                  title: Text('Products'),
                  elevation: 0.0,
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
                endDrawer: filterDrawer(),
                body: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: !_isLoading ? body(level) : Container(),
                    ),
                    Container(
                      color: Colors.deepOrange,
                      height: 59.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              left: 70,
                            ),
                            height: 30.0,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  headerRow(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 59.0),
                      child: model.isLoading || _isLoading
                          ? Container() //LinearProgressIndicator()
                          : Container(),
                    ),
                    level == 0
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
                        backgroundColor: Colors.green[400],
                      ),
                    )
                        : Container(),
                  ],
                )
            ),
          );
        });
  }

  Widget filterDrawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 3.0,
            child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.deepOrange,
                height: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Sort By:  ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                          DropdownButton(
                            underline: Container(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            value: null,
                            hint: Text(
                              _currentItem,
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white60,
                            ),
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Text(
                        '$totalCount Results',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget body(int level) {
    switch (level) {
      case 0:
        return Theme(
          data: ThemeData(primarySwatch: Colors.deepOrange),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: ListView.builder(
                controller: scrollController,
                itemCount: productsByCategory.length + 1,
                itemBuilder: (context, index) {
                  if (index < productsByCategory.length) {
                    return productContainer(context, productsByCategory[index], index);
                  }
                  if (hasMore && productsByCategory.length == 0) {
                    print("LENGTH 00000000");
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: Text(
                          'No Product Found',
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (!hasMore) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: Center(
                        /*child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )*/
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        );
        break;
      case 1:
        // to do later for sub category
        break;
      default:
        return Container();
    }
  }

  Widget headerRow() {
    return Row(
      children: header,
    );
  }

  Widget textField(
      String text, FontWeight fontWeight, int categoryLevel, Color textColor) {
    int sublevel;
    print("LEVEL ${level == 2} BUILDING TEXTFIELD $text");

    return GestureDetector(
        onTap: () {
          sublevel = level - categoryLevel;
          setState(() {
            for (int i = 0; i < sublevel; i++) {
              header.removeLast();
            }
            level = level - sublevel;
          });
          print("LEVEL $level BUILDING TEXTFIELD $text");
        },
        child: Text(
          text,
          style: TextStyle(
              color: level == 2 ? Colors.white : Colors.white60,
              fontSize: 18,
              fontWeight: level == 2 ? FontWeight.w500 : fontWeight),
        ));
  }

  void adjustHeaders(String subCatName) {
    setState(() {
      header.removeLast();
      setState(() {
        header.add(Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white60,
                  size: 16,
                )),
            textField(subCatName, FontWeight.w100, 2, Colors.white)
          ],
        ));
      });
    });
  }

  void loadProductsByCategory([String sortBy]) {
    setState(() {
      currentPage = ONE;
      this.sortBy = sortBy;
      level = 0;
      _isLoading = false;
    });
  }

  Future<bool> _canLeave() {
    if (level == 0) {
      return Future<bool>.value(true);
    } else {
      setState(() {
        level = level - 1;
        header.removeLast();
      });
      return Future<bool>.value(false);
    }
  }

  void changedDropDownItem(String selectedCity) {
    String sortingWith = '';
    setState(() {
      _currentItem = selectedCity;
      switch (_currentItem) {
        case 'Most Viewed':
          sortingWith = 'most_viewed+asc';
          break;
        case 'Most Ordered':
          sortingWith = 'most_ordered+desc ';
          break;
        case 'Most Shared':
          sortingWith = 'most_shared+desc';
          break;
        case 'A TO Z':
          sortingWith = 'name+asc';
          break;
        case 'Z TO A':
          sortingWith = 'name+desc';
          break;
      }

      loadProductsByCategory(sortingWith);
    });
  }
}
