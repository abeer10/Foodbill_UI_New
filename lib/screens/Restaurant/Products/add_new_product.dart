import 'package:flutter/material.dart';
import 'package:shop_app/screens/Restaurant/Products/product_components/body.dart';

class AddProduct extends StatelessWidget {
  Map data;
  AddProduct({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Body(data: data,),
      ),
    );
  }
}
