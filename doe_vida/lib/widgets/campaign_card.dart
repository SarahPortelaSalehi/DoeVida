import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/campanha_detalhes.dart';
import '../repositories/actives_campaigns_repository.dart';
import '../repositories/campaign_repository.dart';
import '../models/campaign.dart';
import '../services/user_service.dart';

class CampaignCard extends StatefulWidget {
  Campaign campanha;

  CampaignCard({Key? key, required this.campanha}) : super(key: key);

  @override
  State<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {
  Map<String, dynamic> _userData = {};

  static Map<String, Color> precoColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.grey,
  };

  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
    });
  }

  abrirDetalhes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignDetailsPage(campaign: widget.campanha),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => abrirDetalhes(),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.asset(
                widget.campanha.icone,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.campanha.titulo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.campanha.codigo.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: precoColor['down']!.withOpacity(0.05),
                  border: Border.all(
                    color: precoColor['down']!.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${widget.campanha.progresso.toString()}/${widget.campanha.progressoEsperado.toString()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: precoColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              if(_userData['userPermission'] == 2) PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('Remover das Campanhas Ativas'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<ActivesCampaignsRepository>(context, listen: false)
                            .remove(widget.campanha);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}