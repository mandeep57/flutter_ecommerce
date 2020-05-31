import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
                centerTitle: false,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Shopping Cart'),
                bottom: model.isLoading
                    ? PreferredSize(
                  child: LinearProgressIndicator(),
                  preferredSize: Size.fromHeight(10),
                )
                    : PreferredSize(
                  child: Container(),
                  preferredSize: Size.fromHeight(10),
                )),
            body: !model.isLoading || model.order != null ? body() : Container(),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                  height: 100,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: itemTotalContainer(model),
                    ),
                    proceedToCheckoutButton(),
                  ]
                  )
              )
            )
        );
      });
  }

  Widget proceedToCheckoutButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 58.0,
              padding: EdgeInsets.all(10),
              child: model.isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                ),
              )
                  : FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                color: Colors.deepOrange,
                child: Text(
                  model.order == null
                      ? 'BROWSE ITEMS'
                      : model.order.itemTotal == '0.0'
                      ? 'BROWSE ITEMS'
                      : 'PROCEED TO CHECKOUT',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onPressed: () async {
                  Fluttertoast.showToast(
                    msg: "Coming Soon...",
                    toastLength: Toast.LENGTH_LONG,
                  );
                },
              ),
            ),
          );
        });
  }

  Widget itemTotalContainer(MainModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[cartData(true), cartData(false)],
    );
  }

  Widget cartData(bool total) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          String getText() {
            return model.order == null
                ? ''
                : model.order.itemTotal == '0.0'
                ? ''
                : total
                ? 'Cart SubTotal (${model.order.totalQuantity} items): '
                : model.order.displaySubTotal;
          }

          return getText() == null
              ? Text('')
              : Text(
            getText(),
            style: total
                ? TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold)
                : TextStyle(
                fontSize: 16.5,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          );
        });
  }

  Widget body() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return CustomScrollView(
          slivers: <Widget>[
            items(),
          ],
        );
      },
    );
  }

  Widget items() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return GestureDetector(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  margin: EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(15),
                                height: 150,
                                width: 100,
                                color: Colors.white,
                                child: FadeInImage(
                                  image: AssetImage('images/placeholders/no-product-image.png'),
                                  placeholder: AssetImage('images/placeholders/no-product-image.png'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Expanded(
                                        // child:
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          width: 150,
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text:
                                                '${"Nike".split(' ')[0]} ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: "Nike",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.black),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        // ),
                                        // Expanded(
                                        // child:
                                        Container(
                                          padding: EdgeInsets.only(top: 0),
                                          child: IconButton(
                                            iconSize: 24,
                                            color: Colors.grey,
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              model.removeProduct(1);
                                            },
                                          ),
                                        ),
                                        // )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                    '\u20B9'"799",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Divider()
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ));
          }, childCount: 5),
        );
      },
    );
  }
}
