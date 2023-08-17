import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static Future<Map<String, dynamic>> getUserDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        return {}; // Retorna um mapa vazio se o usuário não existir
      }
    } catch (e) {
      print('Erro ao buscar detalhes do usuário: $e');
      return {}; // Retorna um mapa vazio em caso de erro
    }
  }
}
