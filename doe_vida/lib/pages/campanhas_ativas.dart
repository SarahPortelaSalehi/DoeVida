import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../models/campaign.dart';
import '../repositories/actives_campaigns_repository.dart';
import '../services/auth_service.dart';
import '../widgets/campaign_card.dart';
import '../widgets/fabmenu_button.dart';

class ActiveCampaignsPage extends StatefulWidget {
  const ActiveCampaignsPage({Key? key}) : super(key: key);

  @override
  State<ActiveCampaignsPage> createState() => _ActiveCampaignsPageState();
}

class _ActiveCampaignsPageState extends State<ActiveCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Campanhas Ativas')),
      ),
      body: Container(
        color: Colors.white30,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('active_campaigns').snapshots(), // Stream data from Firestore
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error loading data from Firebase');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final activeCampaigns = snapshot.data!.docs;

            return activeCampaigns.isEmpty
                ? const ListTile(
              leading: Icon(Icons.star),
              title: Text('Ainda não há campanhas ativas'),
            )
                : ListView.builder(
              itemCount: activeCampaigns.length,
              itemBuilder: (_, index) {
                final campaignData = activeCampaigns[index].data();
                // Assuming your data structure matches your model
                final campaign = Campaign(
                  icone: campaignData['icone'],
                  codigo: campaignData['codigo'],
                  titulo: campaignData['titulo'],
                  descricao: campaignData['descricao'],
                  tiposSanguineos: List<String>.from(campaignData['tiposSanguineos']),
                  localizacao: campaignData['localizacao'],
                  nomePaciente: campaignData['nomePaciente'],
                  progresso: campaignData['progresso'],
                  progressoEsperado: campaignData['progressoEsperado'],
                  userId: campaignData['userId'],
                );
                return CampaignCard(campanha: campaign);
              },
            );
          },
        ),
      ),
      floatingActionButton: FabMenuButton(auth: auth),
    );
  }
}
