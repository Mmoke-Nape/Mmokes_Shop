import 'package:Shop_App/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //   appBar: AppBar(
        //     title: Text(loadedProduct.title),
        //   ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // color: Colors.green,
                    width: size.width,
                    // constraints: BoxConstraints(minHeight: size.height * .4),
                    height: size.height * .5,
                    child: Hero(
                      tag: loadedProduct.id,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 42, vertical: 30),
                    width: size.width,
                    height: size.height * .5,
                    // constraints: BoxConstraints(minHeight: size.height * .5),
                    decoration: const BoxDecoration(
                      color: grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loadedProduct.title,
                          style: TextStyle(fontSize: 30),
                        ),
                        // const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${loadedProduct.price}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Available in stock',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 20),
                        Text(
                          'About',
                          style: TextStyle(fontSize: 25),
                        ),
                        // const SizedBox(height: 20),
                        Text(
                          loadedProduct.description,
                          style: TextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Add to cart",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                const SizedBox(width: 10),
                                SvgPicture.asset(
                                  'assets/icons/add-to-cart.svg',
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: BackButton(),
            ),
          ],
        ),

        // CustomScrollView(
        //   slivers: [
        //     SliverAppBar(
        //       expandedHeight: 300,
        //       pinned: true,
        //       flexibleSpace: FlexibleSpaceBar(
        //         title: T
        //         background: Hero(
        //           tag: loadedProduct.id,
        //           child: Image.network(
        //             loadedProduct.imageUrl,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //     ),
        //     SliverList(
        //       delegate: SliverChildListDelegate(
        //         [
        //           SizedBox(height: 10),
        //           Text(
        //             '\$${loadedProduct.price}',
        //             style: TextStyle(
        //               color: Colors.grey,
        //               fontSize: 20,
        //             ),
        //             textAlign: TextAlign.center,
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10),
        //             width: double.infinity,
        //             child: Text(
        //               loadedProduct.description,
        //               textAlign: TextAlign.center,
        //               softWrap: true,
        //             ),
        //           ),
        //           SizedBox(height: 800),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
