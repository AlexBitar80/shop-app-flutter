// ignore_for_file: sized_box_for_whitespace

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';

import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageUrlFocus = FocusNode();

  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final argument = ModalRoute.of(context)?.settings.arguments;

      if (argument != null) {
        final product = argument as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageController.text = product.imageUrl;
        _descriptionController.text = product.description;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(data: _formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: (_formData['name'] ?? '') as String,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                textInputAction: TextInputAction.next,
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Informe um título válido';
                  }

                  if (value!.trim().length < 3) {
                    return 'Informe um título com no mínimo 3 caracteres';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString() ?? '0.0',
                decoration: const InputDecoration(
                  labelText: 'Preço',
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(
                    moeda: true,
                  ),
                ],
                keyboardType: const TextInputType.numberWithOptions(),
                onSaved: (value) {
                  final cleanedValue =
                      value?.replaceAll(RegExp(r'[^\d,]'), '') ?? '0';
                  final parsedValue =
                      double.tryParse(cleanedValue.replaceAll(',', '.')) ?? 0.0;
                  parsedValue.toStringAsFixed(2);
                  _formData['price'] = parsedValue;
                },
                validator: (value) {
                  final cleanedValue =
                      value?.replaceAll(RegExp(r'[^\d,]'), '') ?? '0';
                  final parsedValue =
                      double.tryParse(cleanedValue.replaceAll(',', '.')) ?? 0.0;

                  if (parsedValue <= 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: _descriptionController,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Informe uma descrição válida';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageController,
                      focusNode: _imageUrlFocus,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Informe uma URL válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageController.text.isEmpty
                        ? const Text('Informe a URL')
                        : Image.network(
                            _imageController.text,
                          ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(
          left: 32,
        ),
        width: double.infinity,
        child: CupertinoButton.filled(
          onPressed: _submitForm,
          child: const Text('Salvar'),
        ),
      ),
    );
  }
}
