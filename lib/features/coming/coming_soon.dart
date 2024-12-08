import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/features/coming/views/widget.dart';

class ComingSoon extends ConsumerWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: commingSoonAppBar(ref),
      body: const Center(
        child: Text("Coming Soon"),
      ),
    );
  }
}
