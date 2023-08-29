import 'package:doe_vida/pages/criar_cupom.dart';

import '../delegates/fab_vertical_delegate.dart';
import 'package:flutter/material.dart';

import '../pages/criar_noticia.dart';
import '../services/auth_service.dart';

class FabMenuRewardsButton extends StatefulWidget {
  final AuthService auth;
  const FabMenuRewardsButton({Key? key, required this.auth}) : super(key: key);

  @override
  State<FabMenuRewardsButton> createState() => _FabMenuRewardsState();
}

class _FabMenuRewardsState extends State<FabMenuRewardsButton>
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
        builder: (_) => const NewCupomPage(),
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
          child: const Icon(Icons.emoji_events_outlined),
        ),
      ],
    );
  }
}
