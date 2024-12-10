import 'package:flutter/material.dart';
class FilterButton extends StatelessWidget {
  final Function onTap;

  const FilterButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
          ),
          child: const Icon(
            Icons.tune_outlined,
            color: Colors.black,
            size: 24,
          ),
        ));
  }
}
