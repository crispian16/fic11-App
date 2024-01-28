import 'package:fic11_starter_pos/core/assets/assets.gen.dart';
import 'package:fic11_starter_pos/core/components/spaces.dart';
import 'package:fic11_starter_pos/core/extensions/build_context_ext.dart';
import 'package:fic11_starter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic11_starter_pos/presentation/home/models/product_category.dart';
import 'package:fic11_starter_pos/presentation/home/models/product_model.dart';
import 'package:fic11_starter_pos/presentation/manage/pages/add_product_page.dart';
import 'package:fic11_starter_pos/presentation/manage/widgets/menu_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductPage extends StatelessWidget {
  const ManageProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> products = [
      ProductModel(
        image: Assets.images.f1.path,
        name: 'Vanila Late Vanila itu',
        category: ProductCategory.drink,
        price: 200000,
        stock: 10,
      ),
      ProductModel(
        image: Assets.images.f2.path,
        name: 'V60',
        category: ProductCategory.drink,
        price: 1200000,
        stock: 10,
      ),
      ProductModel(
        image: Assets.images.f3.path,
        name: 'Americano',
        category: ProductCategory.drink,
        price: 2100000,
        stock: 10,
      ),
      ProductModel(
        image: Assets.images.f4.path,
        name: 'Coklat',
        category: ProductCategory.food,
        price: 200000,
        stock: 10,
      ),
      ProductModel(
        image: Assets.images.f4.path,
        name: 'Coklat',
        category: ProductCategory.food,
        price: 200000,
        stock: 10,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Menu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SpaceHeight(20.0),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                success: (products) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SpaceHeight(20.0),
                    itemBuilder: (context, index) => MenuProductItem(
                      data: products[index],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(const AddProductPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
