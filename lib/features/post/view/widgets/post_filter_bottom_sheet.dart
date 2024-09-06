import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/post/controller/post_filters_providers.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

class PostFilterBottomSheet extends ConsumerWidget {
  final AlwaysAliveProviderBase<PostFilter> filterProvider;
  final Function(PostFilter) onFilterChanged;

  const PostFilterBottomSheet({
    super.key,
    required this.filterProvider,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final sortOptions = ref.watch(sortOptionsProvider);
    final orderOptions = ref.watch(orderOptionsProvider);
    final fieldsOfStudy = ref.watch(fieldOfStudyProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrer Par:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                IconButton(
                  color: AppColors.primaryText,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20,
              children: [
                for (final sortOption in sortOptions)
                  ChoiceChip(
                    selectedColor: AppColors.primaryElementStatus,
                    selectedShadowColor: AppColors.primaryText,
                    label: Text(
                      sortOption.label,
                      style: const TextStyle(
                        color: AppColors.primaryElement,
                      ),
                    ),
                    selected: filter.sort?.value == sortOption.value,
                    onSelected: (selected) {
                      if (selected) {
                        onFilterChanged(filter.copyWith(sort: sortOption));
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Trier par:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20,
              children: [
                for (final orderOption in orderOptions)
                  ChoiceChip(
                    label: Text(
                      orderOption.label,
                      style: const TextStyle(
                        color: AppColors.primaryElement,
                      ),
                    ),
                    selectedColor: AppColors.primaryElementStatus,
                    selectedShadowColor: AppColors.primaryText,
                    selected: filter.order?.value == orderOption.value,
                    onSelected: (selected) {
                      if (selected) {
                        onFilterChanged(filter.copyWith(order: orderOption));
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Domaines d'Etudes:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final fieldOfStudy in fieldsOfStudy)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        side: const BorderSide(color: AppColors.primaryElement),
                        activeColor: AppColors.primaryElementStatus,
                        value: filter.fieldsOfStudy.contains(fieldOfStudy),
                        onChanged: (selected) {
                          final List<FieldOfStudy> newLanguages =
                              List.from(filter.fieldsOfStudy);
                          if (selected != null && selected) {
                            newLanguages.add(fieldOfStudy);
                          } else {
                            newLanguages.remove(fieldOfStudy);
                          }
                          onFilterChanged(
                              filter.copyWith(fieldsOfStudy: newLanguages));
                        },
                      ),
                      Text(
                        fieldOfStudy.label,
                        style: const TextStyle(color: AppColors.primaryElement),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
