import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/models/ProductResponse.dart';
import 'package:heady_ecommerce/models/order.dart';
import 'package:heady_ecommerce/screens/product_detail.dart';
import 'package:scoped_model/scoped_model.dart';

mixin CartModel on Model{
  Order _order;
  bool _isLoading = false;

  Order get order {
    return _order;
  }

  bool get isLoading {
    return _isLoading;
  }

  void addProduct({int productId, int quantity}) {
    Fluttertoast.showToast(
      msg: "Coming Soon...",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void removeProduct(int lineItemId) {
    Fluttertoast.showToast(
      msg: "Coming Soon...",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void createNewOrder(int productId, int quantity) {

  }

  void getProductDetail(Products products, BuildContext context, [bool isSimilarListing = false]) async {
    Products tappedProduct = products;
    notifyListeners();

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductDetailScreen(tappedProduct));
    if (isSimilarListing)
      Navigator.pop(context);

    Navigator.push(context, route);
    notifyListeners();
  }
}