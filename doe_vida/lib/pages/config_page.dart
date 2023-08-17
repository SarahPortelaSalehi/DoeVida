import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';

class ConfigurationsPage extends StatefulWidget {
  ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Configurações')),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${_userData['nome']}'),
            Text('Tipo Sanguíneo: ${_userData['tipoSanguineo']}'),
            Text('Permissão: ${_userData['userPermission']}'),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: OutlinedButton(
                onPressed: () => context.read<AuthService>().logout(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: Colors.red,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Sair do App',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
