import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/campaign_page.dart';
import '../models/campaign.dart';

class InactiveCampaignsPage extends StatelessWidget {
  const InactiveCampaignsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campanhas solicitadas'),
      ),
      body: CampaignList(),
    );
  }
}

class CampaignList extends StatefulWidget {
  @override
  _CampaignListState createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> {
  final List<Campaign> selectedCampaigns = [];

  void _toggleSelect(Campaign campaign) {
    setState(() {
      if (selectedCampaigns.contains(campaign)) {
        selectedCampaigns.remove(campaign);
      } else {
        selectedCampaigns.add(campaign);
      }
    });
  }

  void _reapproveSelectedCampaigns() {
    // Implement the logic to reapprove the selected campaigns here
    // You can use the selectedCampaigns list to process each campaign
    // After reapproval, clear the selectedCampaigns list
    selectedCampaigns.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('campaigns').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No campaigns available.'));
        }

        final campaignDocs = snapshot.data!.docs;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: campaignDocs.length,
                itemBuilder: (context, index) {
                  final campaignData = campaignDocs[index].data() as Map<String, dynamic>;

                  final campaign = Campaign(
                    icone: campaignData['icone'] ?? '',
                    codigo: campaignData['codigo'] ?? 0,
                    titulo: campaignData['titulo'] ?? '',
                    descricao: campaignData['descricao'] ?? '',
                    tiposSanguineos: List<String>.from(campaignData['tiposSanguineos'] ?? []),
                    localizacao: campaignData['localizacao'] ?? '',
                    nomePaciente: campaignData['nomePaciente'] ?? '',
                    progresso: campaignData['progresso'] ?? 0,
                    progressoEsperado: campaignData['progressoEsperado'] ?? 100,
                    userId: campaignData['userId'] ?? '',
                  );

                  return CampaignListItem(
                    campaign: campaign,
                    isSelected: selectedCampaigns.contains(campaign),
                    onToggleSelect: _toggleSelect,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _reapproveSelectedCampaigns();
              },
              child: Text('APROVAR'),
            ),
          ],
        );
      },
    );
  }
}

class CampaignListItem extends StatelessWidget {
  final Campaign campaign;
  final bool isSelected;
  final Function(Campaign) onToggleSelect;

  const CampaignListItem({
    required this.campaign,
    required this.isSelected,
    required this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelected ? const CircleAvatar(child: Icon(Icons.check)) : SizedBox(
        width: 40,
        child: Image.asset(campaign.icone),
      ),
      title: Text(campaign.titulo),
      subtitle: Text(campaign.descricao),
      trailing: Text('${campaign.progresso.toString()} / ${campaign.progressoEsperado.toString()}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CampaignDetailsPage(campaign: campaign),
          ),
        );
      },
      onLongPress: () {
        onToggleSelect(campaign);
      },
    );
  }
}
