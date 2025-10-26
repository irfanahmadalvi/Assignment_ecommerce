import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

import 'package:e_commerce/app/urls.dart';
import 'package:e_commerce/core/models/network_response.dart';
import 'package:e_commerce/core/services/network_caller.dart';
import 'package:e_commerce/features/carts/data/models/cart_item_model.dart';
import 'package:get/get.dart';

class CartListController extends GetxController {
  bool _inProgress = false;

  List<CartItemModel> _cartItemList = [];

  bool get inProgress => _inProgress;

  List<CartItemModel> get cartItemList => _cartItemList;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> getCartList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.cartListUrl,
    );
    if (response.isSuccess) {
      List<CartItemModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']['results']) {
        list.add(CartItemModel.fromJson(jsonData));
      }
      _cartItemList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }

  int get totalPrice {
    int total = 0;
    for (CartItemModel item in _cartItemList) {
      total += (item.quantity * item.product.currentPrice);
    }

    return total;
  }

  void updateCart(String cartItemId, int quantity) {
    _cartItemList.firstWhere((item) => item.id == cartItemId)
        .quantity = quantity;
    update();
  }

  Future<void> deleteCartItem(String cartItemId) async {

    final String deleteUrl = '${Urls.cartListUrl}/$cartItemId';

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: deleteUrl,
    );

    if (response.isSuccess) {

      await getCartList();
    } else {

      Get.snackbar(
        'Error',
        'Failed to remove item: ${response.errorMessage}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkout() async {
    String tranId = "tran_${DateTime.now().millisecondsSinceEpoch}";

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "Electronics",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: "ostad6824b3be647db",
        store_passwd: "ostad6824b3be647db@ssl",
        total_amount: totalPrice.toDouble(),
        tran_id: tranId,
      ),
    );

    try {
      final response = await sslcommerz.payNow();

      if (response.status == 'VALID') {
        debugPrint('Payment success!');
        debugPrint('TxID: ${response.tranId}');
        debugPrint('TxDate: ${response.tranDate}');
        Get.snackbar(
          'Success',
          'Payment Successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } else if (response.status == 'Closed') {
        debugPrint('Payment closed');
        Get.snackbar(
          'Payment Cancelled',
          'You cancelled the payment.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else if (response.status == 'FAILED') {
        debugPrint('Payment failed');
        Get.snackbar(
          'Error',
          'Payment Failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error during payment: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred. $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}