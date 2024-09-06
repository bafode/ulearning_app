import 'package:flutter/material.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/debouncer.dart';

class StyledSearchBar extends StatelessWidget {
  final Duration? debounceDuration;
  final String? hint;
  final Function(String) onSearch;
  late final Debouncer _debouncer;

  StyledSearchBar({
    super.key,
    this.debounceDuration,
    this.hint = "Rechercher...",
    required this.onSearch,
  }) {
    if (debounceDuration != null) {
      _debouncer = Debouncer(duration: debounceDuration!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        onChanged: (val) {
          debounceDuration == null
              ? onSearch(val)
              : _debouncer.run(() {
                  onSearch(val);
                });
        },
        decoration: InputDecoration(
          hintText: hint,
          iconColor: AppColors.primaryElement,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryElement,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: AppColors.primaryElement, width: 1.0),
          ),
        ),
      ),
    );
  }
}
