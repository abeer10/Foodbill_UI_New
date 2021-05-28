import 'package:flutter/material.dart';
import 'package:shop_app/screens/Restaurant/Products/add_new_product.dart';
import 'package:shop_app/screens/Restaurant/Products/components/body.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/coustom_bottom_nav_barR.dart';



class Product_Screen  extends StatelessWidget {
  static String routeName = "/ProductScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      CustomBottomNavBarR(selectedMenu: MenuState2.product),
      appBar: AppBar(
        actions: [
          FlatButton.icon(
              onPressed: () {
                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (BuildContext context) {
                       return AddProduct(data: null,);
                     },
                   ),
                 );
              },
              icon: Icon(Icons.add_circle),
              label: Text('Add Product'))
        ],
        title: Text("Product"),
      ),
      body: Body(),
    );
  }
}
