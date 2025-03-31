import 'package:flutter/material.dart';

class CartGenerator extends StatefulWidget {
  const CartGenerator({super.key});

  @override
  State<CartGenerator> createState() => _CartGeneratorState();
}

class _CartGeneratorState extends State<CartGenerator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Creation de carte membre",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Carte"),
          ),
        ),
      ],
    );
  }
}
