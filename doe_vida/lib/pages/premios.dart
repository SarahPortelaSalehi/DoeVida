import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cupom.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/fabmenu_rewards.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late List<Map<String, dynamic>> _topDonors = []; // Lista dos maiores doadores
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchTopDonors();
    _fetchUserDetails();
  }

  void _deleteCupom(String cupomId) async {
    try {
      final couponRef = FirebaseFirestore.instance.collection('cupom').doc(cupomId);

      // Fetch the coupon's current data
      final couponSnapshot = await couponRef.get();
      final couponData = couponSnapshot.data() as Map<String, dynamic>;
      int currentCouponQuantity = couponData['quantidade'];

      if (currentCouponQuantity > 0) {
        // Update the coupon's quantity to 0
        await couponRef.update({'quantidade': 0});

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cupom Excluído'),
              content: const Text('O cupom foi marcado como excluído.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cupom já excluído'),
              content: const Text('Este cupom já foi marcado como excluído.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Erro ao marcar o cupom como excluído: $e');
    }
  }


  Future<void> _fetchUserDetails() async {
    Map<String, dynamic> userData = await UserService.getUserDetails();
    setState(() {
      _userData = userData;
    });
  }

  Future<void> _fetchTopDonors() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Consulta para obter os 5 maiores doadores com base nos pontosTotais
    final querySnapshot = await usersCollection
        .orderBy('pontosTotais', descending: true)
        .limit(5)
        .get();

    final topDonors = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _topDonors = topDonors;
    });
  }

  void _redeemCoupon(String cupomId, int userPoints, int couponPoints) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      final couponRef = FirebaseFirestore.instance.collection('cupom').doc(cupomId);

      // Fetch the user's current data
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data() as Map<String, dynamic>;
      int currentUserPoints = userData['pontos'];

      // Fetch the coupon's current data
      final couponSnapshot = await couponRef.get();
      final couponData = couponSnapshot.data() as Map<String, dynamic>;
      int currentCouponQuantity = couponData['quantidade'];

      if (currentUserPoints >= couponPoints && currentCouponQuantity > 0) {
        // Update user's points
        await userRef.update({'pontos': currentUserPoints - couponPoints});

        // Add the coupon to redeemed coupons list
        await userRef.update({
          'cuponsResgatados': FieldValue.arrayUnion([cupomId]),
        });

        // Update the coupon's quantity field
        await couponRef.update({'quantidade': currentCouponQuantity - 1});

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cupom resgatado'),
              content: const Text('Você resgatou o cupom com sucesso!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Pontos insuficientes'),
              content: const Text('Você não possui pontos suficientes ou o cupom não está disponível.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error redeeming coupon: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Prêmios')),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ranking Maiores Doadores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _topDonors.length,
            itemBuilder: (context, index) {
              final donor = _topDonors[index];
              final name = donor['nome'];
              final totalPoints = donor['pontosTotais'];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 0),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: ListTile(
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Pontos totais: $totalPoints',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.23,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestore.collection('cupom').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading data from Firebase');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final activeCupons = snapshot.data!.docs.where((cupomData) => cupomData['quantidade'] >= 1);
                return activeCupons.isEmpty
                    ? const ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Ainda não há cupons ativos'),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: activeCupons.length,
                        itemBuilder: (_, index) {
                          final cuponsData = activeCupons.elementAt(index).data();
                          final cupomId = activeCupons.elementAt(index).id;

                          final cupom = Cupom(
                            icone: cuponsData['icone'],
                            titulo: cuponsData['titulo'],
                            valor: cuponsData['valor'],
                            quantidade: cuponsData['quantidade'],
                          );

                          if (cupom.quantidade >= 1) {
                            return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: 200,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    cupom.titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 80,
                                  // Increase the height to show more of the image
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      // Use BoxFit.contain to fit the image without cropping
                                      image: AssetImage(cupom.icone),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll<Color>(
                                              Colors.red),
                                        ),
                                        onPressed: () async {
                                          int userPoints = _userData['pontos']; // Assuming user points are stored under 'pontos' field
                                          int couponPoints = cupom.valor; // Assuming coupon points are stored in 'valor' field
                                          bool hasRedeemed = _userData['cuponsResgatados'].contains(cupomId); // Check if cupomId is in the user's cuponsResgatados array

                                          if (hasRedeemed) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Cupom já resgatado'),
                                                  content: const Text('Você já resgatou este cupom anteriormente.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (userPoints >= couponPoints) {
                                            _redeemCoupon(cupomId, userPoints, couponPoints);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Pontos insuficientes'),
                                                  content: const Text('Você não possui pontos suficientes para resgatar este cupom.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Resgatar por ${cupom.valor} pts',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            //fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),

                                      if (_userData['userPermission'] == 2)
                                        InkWell(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirmar Exclusão'),
                                                  content: const Text(
                                                      'Tem certeza de que deseja excluir este cupom?'),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                          'Cancelar'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text('Excluir'),
                                                      onPressed: () {
                                                        _deleteCupom(cupomId);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                Text(
                                  '${cupom.quantidade} restantes',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          );
                          }
                          return null;
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _userData['userPermission'] == 2
          ? FabMenuRewardsButton(
              auth: auth,
            )
          : null,
    );
  }
}
