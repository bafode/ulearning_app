import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/entities/post/createPostFilter/create_post_filter.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/addPost/provider/post_create_notifier.dart';

class FieldsOfStudySelector extends ConsumerWidget {
  const FieldsOfStudySelector({super.key});

  void _handleFieldOfStudySelection(
    FieldOfStudy fieldOfStudy,
    bool? value,
    CreatePostFilter state,
    CreatePostFilterNotifier notifier,
  ) {
    if (value == true) {
      final updatedFields = [...state.fieldsOfStudy, fieldOfStudy];
      notifier.update(state.copyWith(fieldsOfStudy: updatedFields));
    } else {
      final updatedFields =
          state.fieldsOfStudy.where((f) => f != fieldOfStudy).toList();
      notifier.update(state.copyWith(fieldsOfStudy: updatedFields));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var createPostFilterState = ref.watch(createPostFilterNotifierProvider);
    final createPostFilterNotifier = ref.read(createPostFilterNotifierProvider.notifier);
    final fieldsOfStudy = ref.watch(createPostfieldOfStudyProvider);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Domaines de votre publication",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryElement,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => _showFieldsBottomSheet(context, ref),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primaryElement,
                        size: 24.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Ajouter des domaines",
                        style: TextStyle(
                          color: AppColors.primaryElement,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (createPostFilterState.fieldsOfStudy.isNotEmpty) ...[
            SizedBox(height: 16.h),
            SelectedFieldsDisplay(
              fields: createPostFilterState.fieldsOfStudy,
              onRemove: (fieldOfStudy) {
                final List<FieldOfStudy> newFields =
                    List.from(createPostFilterState.fieldsOfStudy);
                newFields.remove(fieldOfStudy);
                createPostFilterNotifier
                    .update(createPostFilterState.copyWith(fieldsOfStudy: newFields));
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showFieldsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const FieldsBottomSheet(),
    );
  }
}

class SelectedFieldsDisplay extends StatelessWidget {
  final List<FieldOfStudy> fields;
  final Function(FieldOfStudy) onRemove;

  const SelectedFieldsDisplay({
    super.key,
    required this.fields,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final fieldOfStudy in fields)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryElement,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryElement.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fieldOfStudy.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () => onRemove(fieldOfStudy),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18.w,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class FieldsBottomSheet extends ConsumerWidget {
  const FieldsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var createPostFilterState = ref.watch(createPostFilterNotifierProvider);
    final createPostFilterNotifier = ref.read(createPostFilterNotifierProvider.notifier);
    final fieldsOfStudy = ref.watch(createPostfieldOfStudyProvider);

    return StatefulBuilder(
      builder: (context, setModalState) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sélectionner les domaines",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryElement,
                    ),
                  ),
                  if (createPostFilterState.fieldsOfStudy.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        createPostFilterNotifier.update(
                            createPostFilterState.copyWith(fieldsOfStudy: []));
                        setModalState(() {});
                      },
                      child: Text(
                        "Tout désélectionner",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                itemCount: fieldsOfStudy.length,
                itemBuilder: (context, index) {
                  final fieldOfStudy = fieldsOfStudy[index];
                  final isSelected =
                      createPostFilterState.fieldsOfStudy.contains(fieldOfStudy);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              final updatedFields = [
                                ...createPostFilterState.fieldsOfStudy,
                                fieldOfStudy
                              ];
                              createPostFilterNotifier.update(
                                createPostFilterState.copyWith(
                                  fieldsOfStudy: updatedFields,
                                ),
                              );
                            } else {
                              final updatedFields = createPostFilterState
                                  .fieldsOfStudy
                                  .where((f) => f != fieldOfStudy)
                                  .toList();
                              createPostFilterNotifier.update(
                                createPostFilterState.copyWith(
                                  fieldsOfStudy: updatedFields,
                                ),
                              );
                            }
                            setModalState(() {});
                          },
                          activeColor: AppColors.primaryElement,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          fieldOfStudy.label,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: isSelected
                                ? AppColors.primaryElement
                                : Colors.grey.shade700,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
