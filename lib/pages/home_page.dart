import 'package:flat_10plus/product_bloc/product_event.dart';
import 'package:flat_10plus/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/product_related/add_product_page.dart';
import '../product_bloc/product_bloc.dart';
import '../product_bloc/product_state.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return _buildScaffold(context, state);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, ProductState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
      ),
      body: state.filteredProducts.isEmpty
          ? _buildEmptyState(context)
          : _buildProductList(context, state),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomSearchBar(
                  onChanged: (query) {
                    context.read<ProductBloc>().add(SearchProductsEvent(query));
                  }
              ),
              const SizedBox(height: 100),
              const Center(child: Text("Товар не найден"))
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF504BFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 60,
                width: 60,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, ProductState state) {
    return Scaffold(
      body: state.products.isEmpty
          ? Stack(
        children: [
          const Center(child: Text("Товаров нет, добавьте новый")),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF504BFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 60,
                width: 60,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : Stack(
            children: [
              Column(
                children: [
                  CustomSearchBar(
                      onChanged: (query) {
                        context.read<ProductBloc>().add(SearchProductsEvent(query));
                      }
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = state.filteredProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductPage()),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF504BFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 60,
                    width: 60,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
      ),
    );
  }
}