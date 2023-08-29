import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';
import 'editar_noticia.dart';

class NewsDetailsPage extends StatefulWidget {
  final String documentId;

  NewsDetailsPage({required this.documentId});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  Map<String, dynamic> _userData = {};

  late Future<DocumentSnapshot> _newsDetailsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _newsDetailsFuture = FirebaseFirestore.instance
        .collection('news')
        .doc(widget.documentId)
        .get();
  }

  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
    });
  }

  void _deleteNews() async {
    try {
      await FirebaseFirestore.instance
          .collection('news')
          .doc(widget.documentId)
          .delete();
      Navigator.pop(context); // Volta para a tela anterior após excluir
    } catch (e) {
      print('Erro ao excluir notícia: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _newsDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Carregando...'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Erro'),
            ),
            body: const Center(
              child:
                  Text('Ocorreu um erro ao carregar os detalhes da notícia.'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Notícia'),
            ),
            body: const Center(
              child: Text('Não foram encontrados detalhes para esta notícia.'),
            ),
          );
        } else {
          final newsData = snapshot.data!.data() as Map<String, dynamic>;
          final icone = newsData['icone'] ?? 'Ícone não disponível';
          final title = newsData['titulo'] ?? 'Título não disponível';
          final description = newsData['descricao'] ?? 'Descrição não disponível';
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 300, // Customize the image container height
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(color: Colors.grey, width: 2),
                      image: DecorationImage(
                        image: AssetImage(icone),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_userData['userPermission'] == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsEditPage(
                                  documentId: widget
                                      .documentId, // Passe o documentId para a página de detalhes
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirmar Exclusão'),
                                  content: const Text(
                                      'Tem certeza de que deseja excluir esta notícia?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Excluir'),
                                      onPressed: () {
                                        _deleteNews();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
