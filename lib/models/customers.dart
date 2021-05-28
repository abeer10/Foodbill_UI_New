class Customers {
  int id;
  String customerName;
  String mobile;
  int type;

  Customers({this.id, this.customerName, this.mobile, this.type});


  Customers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    mobile = json['mobile'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['customerName'] = customerName;
    data['mobile'] = mobile;
    data['type'] = type;
    return data;
  }




}