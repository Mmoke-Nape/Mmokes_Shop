import 'package:Shop_App/helpers/constants.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
          title: Text(
            'Your Orders',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => LiveList.options(
                  options: options,
                  itemCount: orderData.orders.length,
                  itemBuilder: (
                    ctx,
                    i,
                    Animation<double> animation,
                  ) =>
                      FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1)
                              .animate(animation),
                          child: SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(0, -0.1), end: Offset.zero)
                                .animate(animation),
                            child: OrderItem(
                              orderData.orders[i],
                            ),
                          )),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
