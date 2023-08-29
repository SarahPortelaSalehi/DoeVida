import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsListState extends ChangeNotifier {
  List<String> _cupons = []; // Armazena os títulos das notícias

  List<String> get news => _cupons;

  void updateNews(List<String> cupomTitles) {
    _cupons = cupomTitles;
    notifyListeners(); // Notifica os ouvintes que o estado foi alterado
  }
}