import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NewsListState extends ChangeNotifier {
  List<String> _news = []; // Armazena os títulos das notícias

  List<String> get news => _news;

  void updateNews(List<String> newTitles) {
    _news = newTitles;
    notifyListeners(); // Notifica os ouvintes que o estado foi alterado
  }
}

class GetIconNews extends StatelessWidget {
  final String documentId;

  GetIconNews({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference news = FirebaseFirestore.instance.collection('news');
    return FutureBuilder<DocumentSnapshot>(
      future: news.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error loading news icon');
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data available');
          }

          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Text('Data is null');
          }

          String? iconPath = data['icone'];
          if (iconPath == null) {
            return Text('Icon path is missing');
          }

          return Image.asset(iconPath);
        }

        return const Text('Loading...');
      },
    );
  }
}


class GetTituloNews extends StatelessWidget {
  final String documentId;

  GetTituloNews({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference news = FirebaseFirestore.instance.collection('news');
    return FutureBuilder<DocumentSnapshot>(
      future: news.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              return Text('${data['titulo']}');
            } else {
              return const Text('Data is null'); // Handle the case when data is null
            }
          } else {
            return const Text('Snapshot data is null'); // Handle the case when snapshot data is null
          }
        }
        return const Text('loading..');
      }),
    );
  }
}

class GetDescricaoNews extends StatelessWidget {
  final String documentId;

  GetDescricaoNews({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference news = FirebaseFirestore.instance.collection('news');
    return FutureBuilder<DocumentSnapshot>(
      future: news.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['descricao']}');
        }
        return const Text('loading..');
      }),
    );
  }
}

