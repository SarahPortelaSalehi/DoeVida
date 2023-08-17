import 'package:doe_vida/widgets/fabmenu_rewards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'config_page.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  Map<String, dynamic> _userData = {};

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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Prêmios')),
        actions: <Widget> [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Mostrar Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(),
      floatingActionButton: _userData['userPermission'] == 2
          ? FabMenuRewardsButton(
        auth: auth,
      )
          : null,
    );
  }
}
