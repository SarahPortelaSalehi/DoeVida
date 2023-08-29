import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'meus_cupons.dart';

class ConfigurationsPage extends StatefulWidget {
  ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  Map<String, dynamic> _userData = {};
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bloodTypeController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _pontosController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();

    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
      _nameController.text = _userData['nome'];
      _bloodTypeController.text = _userData['tipoSanguineo'];
      _newEmailController.text = FirebaseAuth.instance.currentUser!.email ?? '';
    });
  }

  Future<void> _updateUserDetails() async {
    Map<String, dynamic> updatedData = {
      'nome': _nameController.text,
      'tipoSanguineo': _bloodTypeController.text,
    };

    await UserService.updateUserDetails(updatedData);
    await _fetchUserDetails();
  }

  Future<void> _updateUserEmail(String newEmail, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
      // Atualização bem-sucedida
      // Você também pode atualizar os detalhes do usuário no Firestore, se necessário
      await _fetchUserDetails(); // Atualizar os detalhes do usuário após a alteração
      _newEmailController.clear(); // Limpar o campo de novo email
      Navigator.pop(context); // Fechar o popup
    } catch (e) {
      print('Erro ao atualizar o email do usuário: $e');
      // Trate o erro conforme necessário
    }
  }

  Future<void> _showChangeEmailDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newEmailController,
                decoration: const InputDecoration(labelText: 'Novo Email'),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha Atual'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newPassword = _newPasswordController.text;
                String newEmail = _newEmailController.text;
                if (newEmail.isNotEmpty && newPassword.isNotEmpty) {
                  await _updateUserEmail(newEmail, newPassword);
                }
                _fetchUserDetails();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserPassword(
      String newPassword, String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: currentPassword,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      // Atualização bem-sucedida
    } catch (e) {
      print('Erro ao atualizar a senha do usuário: $e');
      // Trate o erro conforme necessário
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nova Senha'),
              ),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha Atual'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newPassword = _newPasswordController.text;
                String currentPassword = _currentPasswordController.text;
                if (newPassword.isNotEmpty && currentPassword.isNotEmpty) {
                  await _updateUserPassword(newPassword, currentPassword);
                  Navigator.pop(context); // Fechar o popup
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Configurações')),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _bloodTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo Sanguíneo',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Text(
                  'Pontos: ${_userData['pontos']}',
                )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await _updateUserDetails();
                  },
                  child: const Text('Salvar Alterações'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showChangeEmailDialog(context);
                  },
                  child: const Text('Alterar Email'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showChangePasswordDialog(context);
                  },
                  child: const Text('Alterar Senha'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RedeemedCouponsPage(
                            userId: FirebaseAuth.instance.currentUser!.uid),
                      ),
                    );
                  },
                  child: Text('Meus Cupons Resgatados'),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => context.read<AuthService>().logout(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    primary: Colors.red,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Sair do App',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
