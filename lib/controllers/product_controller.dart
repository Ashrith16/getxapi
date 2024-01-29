import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:getxapi/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  String brand = '';
  ProductController(String value) {
    brand = value;
  }
  var products = [];
  var isLoading = true;
  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() async {
    String url =
        'http://makeup-api.herokuapp.com/api/v1/products.json?brand=$brand';
    Uri ur = Uri.parse(url);
    debugPrint('get started');
    final response = await http.get(ur);
    final body = response.body;
    json.decode(body).forEach(
      (e) async {
        if (await checkImageUrl(e['image_link']) == true) {
          products.add(Product.fromJson(e));
          update();
        }
      },
    );
    debugPrint('get completed');
    isLoading = false;
  }

  Future<bool> checkImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
