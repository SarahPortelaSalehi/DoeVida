import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cupom.dart';

class RedeemedCouponsPage extends StatelessWidget {
  final String userId;

  const RedeemedCouponsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Cupons Resgatados'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRedeemedCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final redeemedCoupons = snapshot.data;

          if (redeemedCoupons == null || redeemedCoupons.isEmpty) {
            return Center(
              child: Text('Você ainda não resgatou nenhum cupom.'),
            );
          }

          return ListView.builder(
            itemCount: redeemedCoupons.length,
            itemBuilder: (context, index) {
              final couponData = redeemedCoupons[index];

              final cupom = Cupom(
                icone: couponData['icone'],
                titulo: couponData['titulo'],
                valor: couponData['valor'],
                quantidade: couponData['quantidade'],
              );

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: ListTile(
                  title: Text(cupom.titulo),
                  leading: Image.asset(cupom.icone), // Assuming icone is an asset path
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchRedeemedCoupons() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final userData = userSnapshot.data() as Map<String, dynamic>;
    final redeemedCouponIds = List<String>.from(userData['cuponsResgatados']);

    final redeemedCoupons = <Map<String, dynamic>>[];

    for (final couponId in redeemedCouponIds) {
      final couponSnapshot = await FirebaseFirestore.instance
          .collection('cupom')
          .doc(couponId)
          .get();

      final couponData = couponSnapshot.data() as Map<String, dynamic>;
      redeemedCoupons.add(couponData);
    }

    return redeemedCoupons;
  }
}
