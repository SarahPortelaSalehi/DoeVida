import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/news_repository.dart';

class NewCupomPage extends StatefulWidget {
  const NewCupomPage({super.key});

  @override
  State<NewCupomPage> createState() => _NewCupomState();
}

class _NewCupomState extends State<NewCupomPage> {
  //final _form = GlobalKey<FormState>();
  final icone = 'images/voucher.png';
  final _tituloCupom = TextEditingController();
  final _valorCupom = TextEditingController();
  final _quantidadeCupom = TextEditingController();

  @override
  void dispose() {
    _tituloCupom.dispose();
    _valorCupom.dispose();
    _quantidadeCupom.dispose();
    super.dispose();
  }

  Future<void> criarCupom(BuildContext context) async {
    await cupom(
      icone,
      _tituloCupom.text.trim(),
      int.parse(_valorCupom.text.trim()),
      int.parse(_quantidadeCupom.text.trim()),
    );

    final cupomListState = Provider.of<NewsListState>(context, listen: false);

    // Create a new list by copying the existing news titles and adding the new title
    final updatedNews = List<String>.from(cupomListState.news);
    updatedNews.add(_tituloCupom.text.trim());

    // Update the state with the updated news list
    cupomListState.updateNews(updatedNews);

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cupom criado!'),
      ),
    );
  }

  Future cupom(
      String icone, String titulo, int valor, int quantidade) async {
    await FirebaseFirestore.instance.collection('cupom').add({
      'icone': icone,
      'titulo': titulo,
      'valor': valor,
      'quantidade': quantidade,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar cupom'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _tituloCupom,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o título da notícia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorCupom,
                // Add a TextEditingController for quantity
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a quantidade do cupom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantidadeCupom,
                // Add a TextEditingController for quantity
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantidade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a quantidade do cupom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () async {
                    await criarCupom(scaffoldContext);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Criar Cupom',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
