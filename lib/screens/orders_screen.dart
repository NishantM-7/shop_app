// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // print("REFRESH");

    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<Orders>(context, listen: false)
    //     .fetchAndSetOrders()
    //     .then((value) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    _ordersFuture = _obtainOrdersFuture();
    // print(_ordersFuture);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('My Orders')),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: ((context, dataSnapshot) {
              // print(dataSnapshot.toString());
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  // print(dataSnapshot.error.toString());
                  return Center(
                    child: Text("An Error Occured!"),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(14),
                        child: Text(
                          'Order Summary',
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Consumer<Orders>(builder: (ctx, orderData, child) {
                        return Expanded(
                          child: orderData.orders.isEmpty
                              ? Center(
                                  child: Text('No Orders Yet'),
                                )
                              : ListView.builder(
                                  itemBuilder: (ctx, i) {
                                    return OrderItem(
                                      orderData.orders[i],
                                    );
                                  },
                                  itemCount: orderData.orders.length,
                                ),
                        );
                      }),
                    ],
                  );
                }
              }
            })));
  }
}
