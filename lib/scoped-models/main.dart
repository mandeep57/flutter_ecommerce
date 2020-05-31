import 'package:heady_ecommerce/scoped-models/cart.dart';
import 'package:heady_ecommerce/scoped-models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with CartModel, UserModel {
}
