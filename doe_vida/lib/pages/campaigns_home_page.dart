import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/campaign_page.dart';
import '../repositories/actives_campaigns_repository.dart';
import '../repositories/campaign_repository.dart';
import '../models/campaign.dart';

class CampaignsHomePage extends StatefulWidget {
  const CampaignsHomePage({Key? key}) : super(key: key);

  @override
  State<CampaignsHomePage> createState() => _CampaignsHomePageState();
}

class _CampaignsHomePageState extends State<CampaignsHomePage> {
  final campanhas = CampanhaRepository.campanhas;
  int qtd = CampanhaRepository.campanhas.length;

  List<Campanha> selecionadas = [];

  late ActivesCampaignsRepository activesCampaigns;

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Center(child: Text('Doe Vida')),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  mostrarDetalhes(Campanha campanha) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignDetailsPage(campanha: campanha),//CampaignDetailsPage
      ),
    );
  }

  limparSelecionadas(){
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // activesCampaigns = Provider.of<ActivesCampaignsRepository>(context);
    activesCampaigns = context.watch<ActivesCampaignsRepository>();
    print('Tem algo $qtd');
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int campanhaIndex) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selecionadas.contains(campanhas[campanhaIndex]))
                ? const CircleAvatar(child: Icon(Icons.check))
                : SizedBox(
                    width: 40,
                    child: Image.asset(campanhas[campanhaIndex].icone),
                  ),
            title: Row(
              children: [
                Text(
                  campanhas[campanhaIndex].titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (activesCampaigns.lista.contains(campanhas[campanhaIndex]))
                  const Icon(Icons.circle, color: Colors.amber, size: 8)
              ],
            ),
            trailing: Text(campanhas[campanhaIndex].progresso.toString()),
            selected: selecionadas.contains(campanhas[campanhaIndex]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selecionadas.contains(campanhas[campanhaIndex]))
                    ? selecionadas.remove(campanhas[campanhaIndex])
                    : selecionadas.add(campanhas[campanhaIndex]);
              });
            },
            onTap: () => mostrarDetalhes(campanhas[campanhaIndex]),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: campanhas.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                activesCampaigns.saveAll(selecionadas);
                limparSelecionadas();
              },
              icon: const Icon(Icons.check),
              label: const Text(
                'APROVAR',
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
