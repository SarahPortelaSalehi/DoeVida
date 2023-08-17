import 'package:flutter/material.dart';
import 'package:doe_vida/models/campaign.dart';

class CampaignDetailsPage extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailsPage({Key? key, required this.campaign})
      : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.campaign.titulo),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(widget.campaign.icone),
              ),
              SizedBox(height: 16),
              Text(
                widget.campaign.descricao,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Paciente: ${widget.campaign.nomePaciente}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Código: ${widget.campaign.codigo}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Localização: ${widget.campaign.localizacao}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tipos sanguíneos solicitados: ${widget.campaign.tiposSanguineos.join(', ')}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Progresso: ${widget.campaign.progresso}/${widget.campaign.progressoEsperado}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text(
          'Participar da Campanha',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          // Coloque aqui o código que você deseja executar quando o botão for pressionado
          // Por exemplo: navegar para outra tela, realizar alguma ação, etc.
          print('Botão APROVAR pressionado!');
        },
      ),

    );
  }
}
