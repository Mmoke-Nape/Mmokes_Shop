import 'package:Shop_App/helpers/constants.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: LiveList.options(
                            options: options,
                            itemCount: productsData.items.length,
                            itemBuilder: (
                              _,
                              i,
                              Animation<double> animation,
                            ) =>
                                FadeTransition(
                              opacity: Tween<double>(
                                begin: 0,
                                end: 1,
                              ).animate(animation),
                              // And slide transition
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, -0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                // Paste you Widget
                                child: Column(
                                  children: [
                                    UserProductItem(
                                      productsData.items[i].id,
                                      productsData.items[i].title,
                                      productsData.items[i].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
