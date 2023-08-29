import 'package:doe_vida/pages/noticias.dart';
import 'package:doe_vida/pages/premios.dart';
import 'package:flutter/material.dart';

import 'campanhas_ativas.dart';
import 'campanhas_inativas.dart';
import 'perfil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: [
          NewsHomePage(),
          ActiveCampaignsPage(),
          RewardsPage(),
          ConfigurationsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                size: 35,
              ),
              label: 'Notícias'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.opacity_sharp,
                size: 35,
              ),
              label: 'Campanhas'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.emoji_events,
                size: 35,
              ),
              label: 'Prêmios'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 35,
              ),
              label: 'Perfil'),

        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.red[50],
      ),
    );
  }
}
