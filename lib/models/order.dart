import 'package:heady_ecommerce/models/address.dart';

class Order {
  final String total;
  final int id;
  final String itemTotal;
  final String displayTotal;
  final String displaySubTotal;
  final String adjustmentTotal;
  final String displayAdjustmentTotal;
  final List<dynamic> adjustments;
  int totalQuantity;
  String shipTotal;
  String state;
  String completedAt, imageUrl, number;
  Address shipAddress;
  final String paymentState, shipState, paymentMethod;

  Order(
      {this.total,
        this.id,
        this.completedAt,
        this.imageUrl,
        this.number,
        this.displayTotal,
        this.displaySubTotal,
        this.adjustmentTotal,
        this.displayAdjustmentTotal,
        this.adjustments,
        this.itemTotal,
        this.shipTotal,
        this.totalQuantity,
        this.state,
        this.shipAddress,
        this.paymentMethod,
        this.paymentState, this.shipState
      });
}