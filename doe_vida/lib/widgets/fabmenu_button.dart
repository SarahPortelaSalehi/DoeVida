import 'package:doe_vida/pages/inactive_campaigns_page.dart';
import 'package:doe_vida/pages/new_campaign.dart';

import '../delegates/fab_vertical_delegate.dart';
import 'package:flutter/material.dart';

import '../pages/new_news_page.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class FabMenuButton extends StatefulWidget {
  final AuthService auth;
  const FabMenuButton({Key? key, required this.auth}) : super(key: key);

  @override
  State<FabMenuButton> createState() => _FabMenuButtonState();
}

class _FabMenuButtonState extends State<FabMenuButton>
    with SingleTickerProviderStateMixin {
  final actionButtonColor = Colors.redAccent.shade100;
  late AnimationController animation;
  final menuIsOpen = ValueNotifier(false);
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
    });
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

  criarCampanha() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewCampaignPage(auth: widget.auth),
      ),
    );
  }

  irparaCampanhas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InactiveCampaignsPage(),
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
          onPressed: () => criarCampanha(),
          backgroundColor: actionButtonColor,
          child: const Icon(Icons.add),
        ),
        if (_userData['userPermission'] == 2) FloatingActionButton(
          onPressed: () => irparaCampanhas(),
          backgroundColor: actionButtonColor,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
