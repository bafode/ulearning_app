import 'package:flutter/material.dart';

class SliverEmptySearch extends StatelessWidget {
  final String text;

  const SliverEmptySearch({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(text, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
