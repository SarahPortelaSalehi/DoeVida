import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final nome = TextEditingController();
  final dropValue = ValueNotifier('');
  final dropOpcoes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final userPermission = 1;

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem-vindo ao Doe Vida';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(email.text, senha.text, nome.text, dropValue.value, userPermission);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                if (!isLogin)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      controller: nome,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o nome corretamente!';
                        }
                        return null;
                      },
                    ),
                  ),
                if (!isLogin)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ValueListenableBuilder(
                      valueListenable: dropValue,
                      builder: (BuildContext context, String value, _) {
                        return SizedBox(
                          width: 500,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            icon: const Icon(Icons.bloodtype),
                            hint: const Text('Tipo sanguíneo'),
                            decoration: InputDecoration(
                              label: const Text('Tipo sanguíneo'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (escolha) =>
                                dropValue.value = escolha.toString(),
                            items: dropOpcoes
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(op),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isLogin) {
                          login();
                        } else {
                          registrar();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  actionButton,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(toggleButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
