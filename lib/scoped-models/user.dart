import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

mixin UserModel on Model{
  bool _isAuthenticated = false;
  MainModel model;

  bool get isAuthenticated {
    return _isAuthenticated;
  }

}