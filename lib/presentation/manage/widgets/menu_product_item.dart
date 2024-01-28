import 'package:cached_network_image/cached_network_image.dart';
import 'package:fic11_starter_pos/core/components/buttons.dart';
import 'package:fic11_starter_pos/core/components/spaces.dart';
import 'package:fic11_starter_pos/core/constants/colors.dart';
import 'package:fic11_starter_pos/core/constants/variables.dart';
import 'package:fic11_starter_pos/data/model/response/product_response_model.dart';
import 'package:flutter/material.dart';

class MenuProductItem extends StatelessWidget {
  final Product data;
  const MenuProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: AppColors.blueLight),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: CachedNetworkImage(
              imageUrl: '${Variables.imageUrl}${data.image}',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(
                Icons.food_bank_outlined,
                size: 70,
              ),
            ),
          ),
          const SpaceWidth(22.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SpaceHeight(5.0),
                Text(
                  data.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SpaceHeight(10.0),
                Row(
                  children: [
                    Flexible(
                      child: Button.outlined(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.all(16.0),
                                  content: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                        const SpaceHeight(10.0),
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${Variables.imageUrl}${data.image}',
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.food_bank_outlined,
                                                size: 80,
                                              ),
                                              width: 80,
                                            )),
                                        const SpaceHeight(10.0),
                                        Text(
                                          data.category,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SpaceHeight(10.0),
                                        Text('Harga: Rp. ${data.price}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            )),
                                        const SpaceHeight(10.0),
                                        Text(
                                          'Stok: ${data.stock}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        label: 'Detail',
                        fontSize: 8.0,
                        height: 31,
                      ),
                    ),
                    const SpaceWidth(6.0),
                    Flexible(
                      child: Button.outlined(
                        onPressed: () {
                          // context.push(EditProductPage(data: data));
                        },
                        label: 'Ubah Produk',
                        fontSize: 8.0,
                        height: 31,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
