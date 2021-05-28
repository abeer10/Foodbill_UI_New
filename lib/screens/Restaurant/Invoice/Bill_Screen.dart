import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_barR.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Invoice/components/body.dart';
import 'package:shop_app/enums.dart';

import 'components/invoice_form.dart';

class Bill_Screen extends StatelessWidget {
  static String routeName = "/Bill_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      CustomBottomNavBarR(selectedMenu: MenuState2.bill),
      appBar: AppBar(

        actions: [
          FlatButton.icon(
              onPressed: () {
                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (BuildContext context) {
                       return NewBill();
                     },
                   ),
                 );
              },
              icon: Icon(Icons.receipt),
              label: Text('Create New Bil'))
        ],
        title: Text("Orders"),
      ),
      body: SingleChildScrollView(
          child: Container(child: Body())
      ),
    );
  }
}
