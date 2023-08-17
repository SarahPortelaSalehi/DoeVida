import '../repositories/actives_campaigns_repository.dart';
import '../services/auth_service.dart';
import '../widgets/campaign_card.dart';
import '../widgets/fabmenu_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config_page.dart';

class ActiveCampaignsPage extends StatefulWidget {
  const ActiveCampaignsPage({super.key});

  @override
  State<ActiveCampaignsPage> createState() => _ActiveCampaignsPageState();
}

class _ActiveCampaignsPageState extends State<ActiveCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Campanhas Ativas')),
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
      body: Container(
        color: Colors.white30,
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: const EdgeInsets.all(12.0),
        child: Consumer<ActivesCampaignsRepository>(
          builder: (context, activeCampaigns, child) {
            return activeCampaigns.lista.isEmpty
                ? const ListTile(
              leading: Icon(Icons.star),
              title: Text('Ainda não há campanhas ativas'),
            )
                : ListView.builder(itemCount: activeCampaigns.lista.length,
              itemBuilder: (_, index) {
                  return CampaignCard(campanha: activeCampaigns.lista[index]);
              },);
          },
        ),
      ),
      floatingActionButton: FabMenuButton(auth: auth),
    );
  }
}
