import 'package:desafio_ziyou/src/player/presentation/pages/player_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Desafio Ziyou',
      debugShowCheckedModeBanner: false,
      home: PlayerPage(),
    );
  }
}
