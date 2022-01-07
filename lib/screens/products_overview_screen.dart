import 'package:Shop_App/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        backgroundColor: grey,
        elevation: 0,
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: SvgPicture.asset('assets/icons/shopping-cart.svg'),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),

      // Center(
      // child: Container(
      //   clipBehavior: Clip.hardEdge,
      //   height: size.height * .35,
      //   width: size.width * .45,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(40),
      //   ),
      //   child: Stack(
      //     children: [
      //       Positioned(
      //         top: 10,
      //         child: Container(
      //           height: size.height * .22,
      //           width: size.width * .45,
      //           child: Image.network(
      //             'https://cdn.shopify.com/s/files/1/2788/1238/products/1_VALPRE-SPARKLING-500ML_600x600.jpg?v=1626699332',
      //             fit: BoxFit.fitHeight,
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         top: 5,
      //         left: 10,
      //         child: IconButton(
      //           onPressed: () {},
      //           icon: Icon(Icons.favorite_border),
      //         ),
      //       ),
      //       Positioned(
      //         left: 10,
      //         bottom: 20,
      //         child: Container(
      //           // color: grey,
      //           child: Column(
      //             children: [
      //               Container(
      //                 // color: Colors.amber,
      //                 width: 115,
      //                 child: Text(
      //                   'Valpre Sparkling Mineral Water 500ml',
      //                   maxLines: 1,
      //                   overflow: TextOverflow.ellipsis,
      //                 ),
      //               ),
      //               const SizedBox(height: 10),
      //               Container(
      //                 // color: Colors.amber,
      //                 width: 115,
      //                 child: Text(
      //                   '\$140',
      //                   style: TextStyle(fontWeight: FontWeight.bold),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         right: 0,
      //         bottom: 0,
      //         child: Container(
      //           width: 53,
      //           height: 65,
      //           decoration: BoxDecoration(
      //             color: Theme.of(context).primaryColor,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(10),
      //               bottomRight: Radius.circular(40),
      //             ),
      //           ),
      //           child: IconButton(
      //             splashRadius: 25,
      //             onPressed: () {},
      //             icon: Icon(Icons.add, color: Colors.white),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      //   ),
    );
  }
}
