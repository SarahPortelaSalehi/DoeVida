import 'package:doe_vida/repositories/campaign_repository.dart';
import 'package:doe_vida/repositories/news_repository.dart';
import 'package:doe_vida/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:doe_vida/pages/my_app.dart';
import 'package:provider/provider.dart';
import '../repositories/actives_campaigns_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsListState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActivesCampaignsRepository(
            auth: context.read<AuthService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
