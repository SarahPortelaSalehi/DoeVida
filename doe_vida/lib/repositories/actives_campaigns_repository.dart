import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repositories/campaign_repository.dart';
import '../services/auth_service.dart';
import '../databases/db_firestore.dart';
import '../models/campaign.dart';

class ActivesCampaignsRepository extends ChangeNotifier {
  List<Campanha> _lista = [];
  late FirebaseFirestore db;
  late AuthService auth;

  ActivesCampaignsRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readActiveCampaigns();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readActiveCampaigns() async {
    if (auth.usuario != null && _lista.isEmpty) {
      try {
        final snapshot = await db.collection('active_campaigns').get();

        for (var doc in snapshot.docs) {
          Campanha campanha = CampanhaRepository.campanhas.firstWhere((campanha) => campanha.codigo == doc.get('codigo'));
          _lista.add(campanha);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Sem nenhuma campanha');
      }
    }
  }

  UnmodifiableListView<Campanha> get lista => UnmodifiableListView(_lista);

  saveAll(List<Campanha> campanhas) async {
    for (var campanha in campanhas) {
      if (!_lista.any((atual) => atual.codigo == campanha.codigo)) {
        _lista.add(campanha);
        try {
          await db.collection('active_campaigns').doc(campanha.codigo.toString()).set({
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
        } on FirebaseException catch (e) {
          debugPrint('Permissão Required no Firestore: $e');
        }
      }
    }
    notifyListeners();
  }
  
  remove(Campanha campanha) async {
    await db.collection('active_campaigns').doc(campanha.codigo.toString()).delete();
    _lista.remove(campanha);
    notifyListeners();
  }

}