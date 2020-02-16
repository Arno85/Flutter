import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth-screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/splash-screen.dart';

import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import 'screens/manage_products_screen.dart';

void main() => runApp(MyApp());

String getToken(String authToken, dynamic previousWidgetState) {
  return authToken == null ? previousWidgetState.authToken : authToken;
}

String getUserId(String userId, dynamic previousWidgetState) {
  return userId == null ? previousWidgetState.userId : userId;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, null),
            update: (ctx, auth, previousState) {
              return Products(getToken(auth.token, previousState), getUserId(auth.userId, previousState));
            },
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, null),
            update: (ctx, auth, previousState) {
              return Orders(getToken(auth.token, previousState), getUserId(auth.userId, previousState));
            },
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            initialRoute: '/',
            routes: {
              '/': (ctx) => auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
              CartScreen.route: (ctx) => CartScreen(),
              OrdersScreen.route: (ctx) => OrdersScreen(),
              ManageProductsScreen.route: (ctx) => ManageProductsScreen(),
              EditProductScreen.route: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
