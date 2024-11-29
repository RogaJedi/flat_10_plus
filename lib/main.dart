import 'package:flat_10plus/api/api_service.dart';
import 'package:flat_10plus/api/cart_api.dart';
import 'package:flat_10plus/api/favorite_api.dart';
import 'package:flat_10plus/api/product_api.dart';
import 'package:flat_10plus/auth/auth_gate.dart';
import 'package:flat_10plus/cart_bloc/cart_event.dart';
import 'package:flat_10plus/favorite_bloc/favorite_event.dart';
import 'package:flat_10plus/product_bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_bloc/cart_bloc.dart';
import 'product_bloc/product_bloc.dart';
import 'product_bloc/product_deletion_bloc.dart';
import 'favorite_bloc/favorite_bloc.dart';
import 'pages/cart_page.dart';
import 'pages/favorite_page.dart';
import 'pages/home_page.dart';
import 'cubit/navigation_cubit.dart';

void main() async {

  await Supabase.initialize(
      url: 'https://anqntjdyplfmcdnkfgyn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFucW50amR5cGxmbWNkbmtmZ3luIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIwNDcxNTMsImV4cCI6MjA0NzYyMzE1M30._PkrMO76mvrUhZFhqDF8vOvjqM3sMdu1keNYGscRjFo'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => FavoriteBloc(
          favoriteApi: FavoriteApi(ApiService()))..add(LoadFavoritesEvent(0)),
        ),
        BlocProvider(create: (context) => CartBloc(cartApi: CartApi(ApiService()))..add(LoadCartEvent(0))
        ),
        BlocProvider(create: (context) => ProductBloc(
            productApi: ProductApi(ApiService()))..add(LoadProductsEvent()),
        ),
        BlocProvider(create: (context) => ProductDeletionBloc(
          productBloc: context.read<ProductBloc>(),
          favoriteBloc: context.read<FavoriteBloc>(),
          cartBloc: context.read<CartBloc>(),
        )),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(),
      FavoritePage(
        productApi: ProductApi(ApiService()),
      ),
      CartPage(
        productApi: ProductApi(ApiService()),
      ),
      AuthGate(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Избранное',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Корзина',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: const Color(0xFF504BFF),
            unselectedItemColor: Colors.grey,
            onTap: (index) => context.read<NavigationCubit>().setPage(index),
          ),
        );
      },
    );
  }
}
