import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product_bloc/product_bloc.dart';
import '../../product_bloc/product_event.dart';
import '../../product_bloc/product_state.dart';

class AddProductPage extends StatelessWidget {

  AddProductPage();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerImage = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerStock = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавьте новый товар"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 100),
              TextField(
                //scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: _controllerName,
                decoration: const InputDecoration(
                  labelText: 'Название',
                ),
                maxLines: 1,
              ),
              TextField(
                //scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: _controllerImage,
                decoration: const InputDecoration(
                  labelText: 'Изображение в формате URL',
                ),
                maxLines: 1,
              ),
              TextField(
                //scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: _controllerDescription,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                ),
                maxLines: 1,
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                //scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: _controllerPrice,
                decoration: const InputDecoration(
                  labelText: 'Стоимость',
                ),
                maxLines: 1,
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                //scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: _controllerStock,
                decoration: const InputDecoration(
                  labelText: 'Количество',
                ),
                maxLines: 1,
              ),
            ],
          ),
          BlocBuilder<ProductBloc, ProductState> (
            builder: (context, state) {
              return Positioned(
                bottom: 50,
                left: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (
                      _controllerName.text.isNotEmpty &&
                      _controllerImage.text.isNotEmpty &&
                      _controllerDescription.text.isNotEmpty &&
                      _controllerPrice.text.isNotEmpty &&
                      _controllerStock.text.isNotEmpty
                    ) {
                      context.read<ProductBloc>().add(
                          AddProductEvent(
                              productId: DateTime.now().millisecondsSinceEpoch,
                              name: _controllerName.text,
                              imageUrl: _controllerImage.text,
                              description: _controllerDescription.text,
                              price: int.parse(_controllerPrice.text),
                              stock: int.parse(_controllerStock.text)
                          ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              );
            }
          )
        ],
      ),

    );
  }
}