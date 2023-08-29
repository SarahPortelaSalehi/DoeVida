import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/news_repository.dart';

class NewNewsPage extends StatefulWidget {
  const NewNewsPage({super.key});

  @override
  State<NewNewsPage> createState() => _NewNewsPageState();
}

class _NewNewsPageState extends State<NewNewsPage> {
  //final _form = GlobalKey<FormState>();
  final icone = 'images/doacao-sangue.png';
  final _tituloNoticia = TextEditingController();
  final _descricaoNoticia = TextEditingController();

  @override
  void dispose() {
    _tituloNoticia.dispose();
    _descricaoNoticia.dispose();
    super.dispose();
  }

  Future<void> criarNoticia(BuildContext context) async {
    await noticia(icone, _tituloNoticia.text.trim(), _descricaoNoticia.text.trim());

    final newsListState = Provider.of<NewsListState>(context, listen: false);

    // Create a new list by copying the existing news titles and adding the new title
    final updatedNews = List<String>.from(newsListState.news);
    updatedNews.add(_tituloNoticia.text.trim());

    // Update the state with the updated news list
    newsListState.updateNews(updatedNews);

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notícia criada!'),
      ),
    );
  }


  Future noticia(String icone, String titulo, String descricao) async {
    await FirebaseFirestore.instance.collection('news').add({
      'icone': icone,
      'titulo': titulo,
      'descricao': descricao,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar notícia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _tituloNoticia,
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
                controller: _descricaoNoticia,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a descrição da notícia';
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
                    await criarNoticia(scaffoldContext);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Criar Notícia',
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
