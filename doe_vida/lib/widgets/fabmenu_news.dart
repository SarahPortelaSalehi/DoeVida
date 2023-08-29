import 'package:doe_vida/pages/campanhas_inativas.dart';
import 'package:doe_vida/pages/criar_campanha.dart';

import '../delegates/fab_vertical_delegate.dart';
import 'package:flutter/material.dart';

import '../pages/criar_noticia.dart';
import '../services/auth_service.dart';

class FabMenuNewsButton extends StatefulWidget {
  final AuthService auth;
  const FabMenuNewsButton({Key? key, required this.auth}) : super(key: key);

  @override
  State<FabMenuNewsButton> createState() => _FabMenuNewsState();
}

class _FabMenuNewsState extends State<FabMenuNewsButton>
    with SingleTickerProviderStateMixin {
  final actionButtonColor = Colors.redAccent.shade100;
  late AnimationController animation;
  final menuIsOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  criarNoticia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NewNewsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FabVerticalDelegate(animation: animation),
      children: [
        FloatingActionButton(
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: animation,
          ),
          onPressed: () => toggleMenu(),
        ),
        FloatingActionButton(
          onPressed: () => criarNoticia(),
          backgroundColor: actionButtonColor,
          child: const Icon(Icons.library_books),
        ),
      ],
    );
  }
}
