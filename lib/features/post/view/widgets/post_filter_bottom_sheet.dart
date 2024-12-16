import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/post/controller/post_filters_providers.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

class PostFilterBottomSheet extends ConsumerWidget {
  final ProviderBase<PostFilter> filterProvider;
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            
            Wrap(
              spacing: 20,
              children: [
                for (final sortOption in sortOptions)
                 ChoiceChip(
                    selectedColor: AppColors
                        .primaryElement, 
                    selectedShadowColor:
                        AppColors.primaryText, 
                    label: Text(
                      sortOption.label,
                      style: TextStyle(
                        color: filter.category?.value == sortOption.value
                            ? Colors.white 
                            : AppColors.primaryElement, 
                        fontSize: 12,
                      ),
                    ),
                    selected: filter.category?.value == sortOption.value,
                    onSelected: (selected) {
                      if (selected && filter.category?.value != sortOption.value) {
                        onFilterChanged(filter.copyWith(category: sortOption));
                      } else {
                        onFilterChanged(filter.copyWith(category: null));
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
                color: Colors.black,
              ),
            ),
            Wrap(
              spacing: 20,
              children: [
                for (final orderOption in orderOptions)
                  ChoiceChip(
                    label: Text(
                      orderOption.label,
                      style: TextStyle(
                        color: filter.order?.value == orderOption.value
                            ? Colors.white // White text when selected
                            : AppColors.primaryElement, // Default color
                        fontSize: 12,
                      ),
                    ),
                    selectedColor: AppColors.primaryElement,
                    selectedShadowColor: Colors.black,
                    selected: filter.order?.value == orderOption.value,
                    onSelected: (selected) {
                      if (selected&& filter.order?.value != orderOption.value) {
                        onFilterChanged(filter.copyWith(order: orderOption));
                      }
                       else {
                        onFilterChanged(filter.copyWith(order: null));
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
                color: Colors.black,
              ),
            ),
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
                        activeColor: AppColors.primaryElement,
                        value: filter.fieldsOfStudy.contains(fieldOfStudy),
                        onChanged: (selected) {
                          final List<FieldOfStudy> newFields =
                              List.from(filter.fieldsOfStudy);
                          if (selected != null && selected) {
                            newFields.add(fieldOfStudy);
                          } else {
                            newFields.remove(fieldOfStudy);
                          }
                          onFilterChanged(
                              filter.copyWith(fieldsOfStudy: newFields));
                        },
                      ),
                      Text(
                        fieldOfStudy.label,
                        style: const TextStyle(
                            color: AppColors.primaryElement, fontSize: 12),
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
