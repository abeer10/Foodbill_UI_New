
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_app/screens/Restaurant/Products/product_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';


class AddProduct extends StatefulWidget {
  Map data;
  AddProduct({this.data});
  @override
  _AddProduct_FormState createState() => _AddProduct_FormState();
}

class _AddProduct_FormState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
 TextEditingController productNameCtrl = TextEditingController();
 TextEditingController productPriceCtrl = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userId;
  String imagePath;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    userId = firebaseAuth.currentUser.uid;
    print(widget.data);
    if(widget.data != null) {
      productNameCtrl.text =
      widget.data["name"] == null ? null : widget.data["name"];
      productPriceCtrl.text =
      widget.data["price"] == null ? null : widget.data["price"].toString();
    }
    print(userId);

    // TODO: implement initState
    super.initState();
  }


  _imgFromGallery() async {
    var image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    _uploadImageToFirebase(image);

//    setState(() {
//      _image = image;
//    });
  }



  Future<void> _uploadImageToFirebase(var image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image${randomNumber}.jpg';

      // Upload image to firebase.
      final Reference storageReference = FirebaseStorage.instance.ref().child(imageLocation);
      final UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      final TaskSnapshot downloadUrl = (await uploadTask);
      imagePath = await downloadUrl.ref.getDownloadURL();
      print(imagePath);
      // await post();
      setState(() {
        imagePath = imagePath;
      });
//      setState(() {
//        _saving = false;
//      });
    }catch(e){
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 500,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.rectangle,
                ),
                child: imagePath == null || imagePath == "" ?
                Image.asset("assets/images/biryani.jpeg", fit: BoxFit.fill,) :
                CachedNetworkImage(
                  imageUrl: '$imagePath',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 500,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: (){
                      _imgFromGallery();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          //SizedBox(height: getProportionateScreenHeight(30)),
         // buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //buildAboutFormField(),
          //SizedBox(height: getProportionateScreenHeight(30)),

          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          // buildNotificationOptionRow("Dine In", true),
          // buildNotificationOptionRow("Take Away", true),
          // buildNotificationOptionRow("Delivery", false),
          SizedBox(height: getProportionateScreenHeight(20)),
          widget.data != null ?
          DefaultButton(
            text: "Save",
            press: () async {
              if (_formKey.currentState.validate()) {
                var num = Random();
                int itemNo = num.nextInt(10000);
                await _firestore.collection("restaurants_products").doc(userId).collection("products").doc(widget.data["itemNo"].toString()).update({
                  "name" : productNameCtrl.text,
                  "price" : int.parse(productPriceCtrl.text),
                  "pic" : imagePath,
                  "itemNo" : widget.data["itemNo"],
                  "qty" : 0,

                }).then((value){
                  print("successfully entered");
                });
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Product_Screen()), (Route<dynamic> route) => false);
              }
            },
          )

          : DefaultButton(
            text: "Add",
            press: () async {
              if (_formKey.currentState.validate()) {
                var num = Random();
                int itemNo = num.nextInt(10000);
                await _firestore.collection("restaurants_products").doc(userId).collection("products").doc(itemNo.toString()).set({
                  "name" : productNameCtrl.text,
                  "price" : int.parse(productPriceCtrl.text),
                  "pic" : imagePath,
                  "itemNo" : itemNo,
                  "qty" : 0,

                }).then((value){
                  print("successfully entered");
                });
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Product_Screen()), (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: productNameCtrl,
      keyboardType: TextInputType.text,

      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kProductNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kProductNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter Product Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: productPriceCtrl,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kProductlNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kProductlNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        hintText: "Enter Product Price",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  //==== ADDRESS =====
  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,

      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter Restaurant Address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }



  //==============
  TextFormField buildAboutFormField() {
    return  TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,


      decoration: InputDecoration(
        labelText: "About",
        hintText: "About your Restaurant",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }





  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}
