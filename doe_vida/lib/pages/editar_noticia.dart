import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsEditPage extends StatefulWidget {
  final String documentId;

  NewsEditPage({required this.documentId});

  @override
  State<NewsEditPage> createState() => _NewsEditPageState();
}

class _NewsEditPageState extends State<NewsEditPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _updateNews() async {
    try {
      await FirebaseFirestore.instance.collection('news').doc(widget.documentId).update({
        'titulo': _titleController.text,
        'descricao': _descriptionController.text,
        // Outros campos que você pode querer atualizar
      });

      // Volta para a página de detalhes após a edição
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar notícia: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // Busca os detalhes da notícia com base no widget.documentId
    FirebaseFirestore.instance.collection('news').doc(widget.documentId).get().then(
          (snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> newsData = snapshot.data() as Map<String, dynamic>;
          _titleController.text = newsData['titulo'] ?? '';
          _descriptionController.text = newsData['descricao'] ?? '';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Notícia'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateNews, // Chama a função de atualização ao pressionar o botão
              child: const Text('Salvar Edições'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
