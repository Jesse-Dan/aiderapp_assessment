import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String text;
  const EmptyView(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}