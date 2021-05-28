import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/History/orders.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/details.dart';

class TrendingItem extends StatefulWidget {
  final String img;
  final String title;
  final String address;
  final int rating;
  Map restaurant;
  TrendingItem({
    Key key,
    @required this.img,
    @required this.title,
    @required this.address,
    @required this.rating,
    this.restaurant
  }) : super(key: key);

  @override
  _TrendingItemState createState() => _TrendingItemState();
}

class _TrendingItemState extends State<TrendingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ProductDetails(data: widget.restaurant,);
                                  },
                                ),
                              );

      },
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 3.5,
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 5.5,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          "${widget.img}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Constants.ratingBG,
                                size: 10.0,
                              ),
                              Text(
                                " ${widget.rating} ",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
//                  Positioned(
//                    top: 6.0,
//                    left: 6.0,
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(3.0)),
//                      child: Padding(
//                        padding: EdgeInsets.all(4.0),
//                        child: Text(
//                          " OPEN ",
//                          style: TextStyle(
//                            fontSize: 10.0,
//                            color: Colors.green,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Positioned(
//                    top: 50.0,
//                    left: 6.0,
//                    child: Card(
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(3.0)),
//                        child: IconButton(
//                            icon: Icon(Icons.remove_red_eye),
//                            onPressed: () {
//                              Navigator.of(context).push(
//                                MaterialPageRoute(
//                                  builder: (BuildContext context) {
//                                    return ProductDetails();
//                                  },
//                                ),
//                              );
//                            })),
//                  ),
                  ],
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${widget.title}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${widget.address}",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
