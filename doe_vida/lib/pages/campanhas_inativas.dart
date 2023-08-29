import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../pages/campanha_detalhes.dart';
import '../models/campaign.dart';
import '../repositories/selected_provider.dart';

class InactiveCampaignsPage extends StatefulWidget {
  const InactiveCampaignsPage({Key? key}) : super(key: key);


  @override
  _InactiveCampaignsState createState() => _InactiveCampaignsState();
}

class _InactiveCampaignsState extends State<InactiveCampaignsPage> {

  @override
  Widget build(BuildContext context) {
    final selectedCampaignsProvider = context.watch<SelectedCampaignsProvider>();
    return Scaffold(
      appBar: appBarDinamica(selectedCampaignsProvider),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('campaigns').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Sem campanhas solicitadas.'));
          }

          final campaignDocs = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final campaignData =
                        campaignDocs[index].data() as Map<String, dynamic>;

                    final campaign = Campaign(
                      icone: campaignData['icone'],
                      codigo: campaignData['codigo'],
                      titulo: campaignData['titulo'],
                      descricao: campaignData['descricao'],
                      tiposSanguineos:
                          List<String>.from(campaignData['tiposSanguineos']),
                      localizacao: campaignData['localizacao'],
                      nomePaciente: campaignData['nomePaciente'],
                      progresso: campaignData['progresso'],
                      progressoEsperado: campaignData['progressoEsperado'],
                      userId: campaignData['userId'],
                    );

                    return ListTile(
                      leading: selectedCampaignsProvider.selectedCampaigns.contains(campaign)
                          ? const CircleAvatar(child: Icon(Icons.check))
                          : SizedBox(
                              width: 40,
                              child: Image.asset(campaignData['icone']),
                            ),
                      selected: selectedCampaignsProvider.selectedCampaigns.contains(campaign),
                      selectedTileColor: selectedCampaignsProvider.selectedCampaigns.contains(campaign)
                          ? Colors.grey[200] // Change this color to indicate selection
                          : Colors.transparent,
                      title: Text(campaignData['titulo']),
                      subtitle: Text(campaign.descricao),
                      trailing: Text(
                          '${campaign.progresso.toString()} / ${campaign.progressoEsperado.toString()}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CampaignDetailsPage(campaign: campaign),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (selectedCampaignsProvider.selectedCampaigns.contains(campaign)) {
                          selectedCampaignsProvider.removeFromSelected(campaign);
                        } else {
                          selectedCampaignsProvider.addToSelected(campaign);
                        }
                      },

                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: campaignDocs.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      for (var campaign in selectedCampaignsProvider.selectedCampaigns) {
                        // Adicionar campanha à coleção active_campaigns
                        await FirebaseFirestore.instance
                            .collection('active_campaigns')
                            .doc(campaign.codigo.toString())
                            .set({
                          'codigo': campaign.codigo,
                          'descricao': campaign.descricao,
                          'icone': campaign.icone,
                          'localizacao': campaign.localizacao,
                          'nomePaciente': campaign.nomePaciente,
                          'progresso': campaign.progresso,
                          'progressoEsperado': campaign.progressoEsperado,
                          'tiposSanguineos': campaign.tiposSanguineos,
                          'titulo': campaign.titulo,
                          'userId': campaign.userId,
                        });

                        await FirebaseFirestore.instance
                              .collection('campaigns')
                              .doc(campaign.codigo.toString())
                              .delete();
                      }

                      selectedCampaignsProvider.clearSelected();
                      Navigator.pop(context);
                    },
                    child: const Text('APROVAR'),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    onPressed: () async {
                      for (var campaign in selectedCampaignsProvider.selectedCampaigns) {
                        await FirebaseFirestore.instance
                            .collection('campaigns')
                            .doc(campaign.codigo.toString())
                            .delete();
                      }
                      selectedCampaignsProvider.clearSelected();
                      Navigator.pop(context);
                    },
                    child: const Text('REPROVAR'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

AppBar appBarDinamica(SelectedCampaignsProvider selectedCampaignsProvider) {
  if (selectedCampaignsProvider.selectedCampaigns.isEmpty) {
    return AppBar(
      title: const Text('Campanhas solicitadas'),
    );
  } else {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          selectedCampaignsProvider.clearSelected();
        },
      ),
      title: Text('${selectedCampaignsProvider.selectedCampaigns.length} selecionadas'),
      backgroundColor: Colors.blueGrey[50],
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
      toolbarTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
