import 'package:flutter/material.dart';
import 'package:doe_vida/models/campaign.dart';

class CampaignDetailsPage extends StatefulWidget {
  final Campanha campanha;

  const CampaignDetailsPage({Key? key, required this.campanha})
      : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.campanha.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(widget.campanha.icone),
            ),
            SizedBox(height: 16),
            Text(
              widget.campanha.descricao,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Paciente: ${widget.campanha.nomePaciente}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Código: ${widget.campanha.codigo}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Localização: ${widget.campanha.localizacao}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tipos sanguíneos solicitados: ${widget.campanha.tiposSanguineos.join(', ')}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Progresso: ${widget.campanha.progresso}/${widget.campanha.progressoEsperado}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
