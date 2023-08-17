import 'package:doe_vida/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../repositories/campaign_repository.dart';
import 'package:doe_vida/models/campaign.dart';

class NewCampaignPage extends StatefulWidget {
  final AuthService auth;
  const NewCampaignPage({super.key, required this.auth});

  @override
  State<NewCampaignPage> createState() => _NewCampaignPageState();
}

class _NewCampaignPageState extends State<NewCampaignPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _form = GlobalKey<FormState>();
  final _codigo = TextEditingController();
  final titulo = TextEditingController();
  final descricao = TextEditingController();
  final bloodOptions = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final tiposSanguineos = [
    'A+',
    'O',
  ];
  final localizacao = TextEditingController();
  final nomePaciente = TextEditingController();
  final dropValue = ValueNotifier('');
  final dropOpcoes = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  late AuthService auth;

  List<String> selectedBloodTypes = []; // List to store selected blood types

  void selectBloodType(String bloodType) {
    if (selectedBloodTypes.contains(bloodType)) {
      setState(() {
        selectedBloodTypes.remove(bloodType);
      });
    } else {
      setState(() {
        selectedBloodTypes.add(bloodType);
      });
    }
  }

  createCampaign() async {
    if (_form.currentState!.validate()) {
      final int codigo = int.parse(_codigo.text);
      final Campanha newCampanha = Campanha(
        icone: 'images/gota.png',
        codigo: codigo,
        titulo: titulo.text,
        descricao: descricao.text,
        tiposSanguineos: selectedBloodTypes,
        localizacao: localizacao.text,
        nomePaciente: nomePaciente.text,
        progresso: 0,
        progressoEsperado: int.parse(dropValue.value),
        userId: user.uid,
      );

      await CampanhaRepository.createCampaignInFirestore(newCampanha);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campanha criada!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar campanha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _codigo,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Código',
                        prefixIcon: Icon(Icons.code),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o número do código da doação';
                        } else if (int.parse(value) < 10000) {
                          return 'Código possivelmente incorreto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titulo,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Título',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o título da campanha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descricao,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe a descrição da campanha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: bloodOptions.map((bloodType) {
                        final isSelected =
                            selectedBloodTypes.contains(bloodType);
                        return FilterChip(
                          label: Text(bloodType),
                          selected: isSelected,
                          onSelected: (_) => selectBloodType(bloodType),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: localizacao,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Localização',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe a localização da campanha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nomePaciente,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do Paciente',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o nome do paciente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: dropValue,
                      builder: (BuildContext context, String value, _) {
                        return SizedBox(
                          width: 500,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: const Text('Quantidade de doações desejadas'),
                            decoration: InputDecoration(
                              label: const Text('Quantidade'),
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
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(top: 24),
                      child: ElevatedButton(
                        onPressed: createCampaign,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Criar Campanha',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
