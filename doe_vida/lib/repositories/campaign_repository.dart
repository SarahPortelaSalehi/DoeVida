import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doe_vida/models/campaign.dart';

class CampanhaRepository {
  static List<Campaign> campanhas = [];

  static Future<void> fetchCampanhasFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('campaigns').get();

      campanhas = snapshot.docs.map((doc) {
        return Campaign(
          icone: doc.get('icone'),
          codigo: doc.get('codigo'),
          titulo: doc.get('titulo'),
          descricao: doc.get('descricao'),
          tiposSanguineos: List<String>.from(doc.get('tiposSanguineos')),
          localizacao: doc.get('localizacao'),
          nomePaciente: doc.get('nomePaciente'),
          progresso: doc.get('progresso'),
          progressoEsperado: doc.get('progressoEsperado'),
          userId: doc.get('userId'),
        );
      }).toList();

    } catch (e) {
      print('Error fetching campaigns from Firestore: $e');
    }
  }

  static Future<void> createCampaignInFirestore(Campaign campanha) async {
    try {
      await FirebaseFirestore.instance.collection('campaigns').add({
        'icone': campanha.icone,
        'codigo': campanha.codigo,
        'titulo': campanha.titulo,
        'descricao': campanha.descricao,
        'tiposSanguineos': campanha.tiposSanguineos,
        'localizacao': campanha.localizacao,
        'nomePaciente': campanha.nomePaciente,
        'progresso': campanha.progresso,
        'progressoEsperado': campanha.progressoEsperado,
        'userId': campanha.userId,
      });
    } catch (e) {
      print('Error creating campaign in Firestore: $e');
    }
  }
}