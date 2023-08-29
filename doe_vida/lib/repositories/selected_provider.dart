import 'package:flutter/material.dart';
import '../models/campaign.dart';

class SelectedCampaignsProvider extends ChangeNotifier {
  final List<Campaign> _selectedCampaigns = [];

  List<Campaign> get selectedCampaigns => _selectedCampaigns;

  void addToSelected(Campaign campaign) {
    _selectedCampaigns.add(campaign);
    notifyListeners();
  }

  void removeFromSelected(Campaign campaign) {
    _selectedCampaigns.remove(campaign);
    notifyListeners();
  }

  void clearSelected() {
    _selectedCampaigns.clear();
    notifyListeners();
  }
}
