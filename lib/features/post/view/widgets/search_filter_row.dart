import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:ulearning_app/common/utils/app_colors.dart';
//import 'package:ulearning_app/features/post/domain/post_filter.dart';
//import 'package:ulearning_app/features/post/view/widgets/filter_botton.dart';
//import 'package:ulearning_app/features/post/view/widgets/post_filter_bottom_sheet.dart';
import 'package:ulearning_app/features/post/view/widgets/search_bar.dart';

class SearchFilterRow extends ConsumerWidget {
  final Function(String) onSearch;
  //final AlwaysAliveProviderBase<PostFilter> filterProvider;
  //final Function(PostFilter) onFilterChanged;

  const SearchFilterRow({
    super.key,
    required this.onSearch,
   // required this.filterProvider,
    //required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: StyledSearchBar(
                onSearch: onSearch,
                debounceDuration: const Duration(milliseconds: 500),
              ),
            ),
            // const SizedBox(width: 8),
            // FilterButton(
            //   onTap: () {
            //     showModalBottomSheet(
            //       backgroundColor: AppColors.primaryElement,
            //       context: context,
            //       builder: (BuildContext context) {
            //         return PostFilterBottomSheet(
            //           filterProvider: filterProvider,
            //           onFilterChanged: onFilterChanged,
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
