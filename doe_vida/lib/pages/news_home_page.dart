import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news.dart';
import '../repositories/news_repository.dart';
import '../services/auth_service.dart';
import '../widgets/fabmenu_news.dart';
import 'config_page.dart';
import 'news_details_page.dart';
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

  Future getDocId() async {
    docIDs.clear();
    await FirebaseFirestore.instance.collection('news').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  void initState() {
    super.initState();
    _fetchDocumentIDs();
    _fetchUserDetails();
  }

  Future<void> _fetchDocumentIDs() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('news').get();
      final newDocIDs = snapshot.docs.map((document) => document.id).toList();

      setState(() {
        docIDs = newDocIDs;
      });
      final newsListState = Provider.of<NewsListState>(context, listen:false);
      newsListState.updateNews(newDocIDs);
    } catch (e) {
      // Handle error
      print('Error fetching document IDs: $e');
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Notícias')),
      ),
      body: Consumer<NewsListState>(
        //future: getDocId(),
        builder: (context, newsListState, child) {
          final newsListState = Provider.of<NewsListState>(context);
          return ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 2,
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  leading: SizedBox(
                      width: 40,
                      child: GetIconNews(
                        documentId: newsListState.news[index],
                      )),
                  title: Row(
                    children: [
                      GetTituloNews(
                        documentId: newsListState.news[index],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(
                          documentId: newsListState.news[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: newsListState.news.length,
          );
        },
      ),
      floatingActionButton: _userData['userPermission'] == 2
          ? FabMenuNewsButton(
        auth: auth,
      )
          : null,
    );
  }
}
