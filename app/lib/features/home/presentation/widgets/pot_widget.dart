import 'package:flutter/material.dart';

class PotWidget extends StatelessWidget {
  const PotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/pots/pot_1.png',
      width: 200,
      fit: BoxFit.contain,
    );
  }
}
