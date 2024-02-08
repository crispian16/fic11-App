// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:fic11_starter_pos/data/datasources/product_local_datasources.dart';
import 'package:fic11_starter_pos/data/datasources/product_remote_datasource.dart';
import 'package:fic11_starter_pos/data/model/request/product_request_model.dart';
import 'package:fic11_starter_pos/data/model/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this._productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      final response = await _productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products = r.data;
          emit(ProductState.success(r.data));
        },
      );
    });

    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      final localProducts =
          await ProductLocalDatasources.instance.getAllProducts();
      products = localProducts;
      emit(ProductState.success(products));
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());
      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();

      emit(ProductState.success(newProducts));
    });

    on<_AddProduct>((event, emit) async {
      emit(const ProductState.loading());
      final requestData = ProductRequestModel(
        name: event.product.name,
        price: event.product.price,
        stock: event.product.stock,
        category: event.product.category,
        isBestSeller: event.product.isBestSeller ? 1 : 0,
        image: event.image,
      );
      final response = await _productRemoteDatasource.addProduct(requestData);
      // products.add(newProduct);
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products.add(r.data);
          emit(ProductState.success(products));
        },
      );
      emit(ProductState.success(products));
    });
  }
}
