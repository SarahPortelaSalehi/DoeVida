import 'package:flutter/material.dart';
import 'package:doe_vida/models/campaign.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import '../widgets/widget_to_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CampaignDetailsPage extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailsPage({Key? key, required this.campaign})
      : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  late GlobalKey key1;

  Future<void> shareCampanha() async {
    RenderRepaintBoundary? boundary = key1.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage();
    ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/photo.png');
    await imgFile.writeAsBytes(pngBytes!);

    final files = <XFile> [];
    files.add(XFile(imgFile.path));

    await Share.shareXFiles(files, subject: 'Campanha');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.campaign.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: shareCampanha,
          ),
        ],
      ),
      body: WidgetToImage(
        builder: (key){
          key1 = key;
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200, // Customize the image container height
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.grey, width: 2),
                          image: DecorationImage(
                            image: AssetImage(widget.campaign.icone),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text(
                          widget.campaign.descricao,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text(
                          'Paciente: ${widget.campaign.nomePaciente}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text(
                          'Código: ${widget.campaign.codigo}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text(
                          'Localização: ${widget.campaign.localizacao}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text(
                          'Tipos sanguíneos solicitados: ${widget.campaign.tiposSanguineos.join(', ')}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: 20,
                                  value: widget.campaign.progresso /
                                      widget.campaign.progressoEsperado,
                                  valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.red),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${widget.campaign.progresso}/${widget.campaign.progressoEsperado} doações',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
        onPressed: () async {
          try {
            final campaignDocRef = firestore.collection('active_campaigns').doc(widget.campaign.codigo.toString());

            // Check if user has already participated in the campaign
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              final userDocRef = firestore.collection('users').doc(currentUser.uid);
              final userSnapshot = await userDocRef.get();

              final campanhasParticipadas = userSnapshot['campanhasParticipadas'] ?? [];
              if (!campanhasParticipadas.contains(widget.campaign.codigo.toString())) {
                await campaignDocRef.update({
                  'progresso': FieldValue.increment(1),
                });

                setState(() {
                  widget.campaign.progresso += 1;
                });

                // Update user's points fields
                await userDocRef.update({
                  'pontos': FieldValue.increment(5),
                  'pontosTotais': FieldValue.increment(5),
                });

                // Add campaign code to participated list
                await userDocRef.update({
                  'campanhasParticipadas': FieldValue.arrayUnion([widget.campaign.codigo.toString()]),
                });

                // Show success message using a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Você participou com sucesso da campanha."),
                  ),
                );
              } else {
                // Show already participated message using a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Você já participou desta campanha."),
                  ),
                );
              }
            }
          } catch (e) {
            print("Error updating document: $e");
          }
        },


      ),
    );
  }
}

