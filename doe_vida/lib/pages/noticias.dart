import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news.dart';
import '../repositories/news_repository.dart';
import '../services/auth_service.dart';
import '../widgets/fabmenu_news.dart';
import 'perfil.dart';
import 'noticia_detalhes.dart';
import '../services/user_service.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({Key? key}) : super(key: key);

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> _userData = {};

  List<String> docIDs = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Notícias')),
      ),
      body: Container(
        color: Colors.white30,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('news').snapshots(), // Stream data from Firestore
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error loading data from Firebase');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final activeNews = snapshot.data!.docs;

            return activeNews.isEmpty
                ? const ListTile(
              leading: Icon(Icons.star),
              title: Text('Ainda não há notícias ativas'),
            )
                : ListView.builder(
              itemCount: activeNews.length,
              itemBuilder: (_, index) {
                final newsData = activeNews[index].data();
                final news = News(
                  icone: newsData['icone'],
                  titulo: newsData['titulo'],
                  descricao: newsData['descricao'],
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(
                          documentId: activeNews[index].id,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(news.icone),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              news.titulo,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
      floatingActionButton: _userData['userPermission'] == 2
          ? FabMenuNewsButton(
        auth: auth,
      )
          : null,
    );
  }
}
