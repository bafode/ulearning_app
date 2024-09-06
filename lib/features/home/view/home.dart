import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/features/home/controller/home_controller.dart';
import 'package:ulearning_app/features/home/view/widgets/home_widget.dart';
import 'package:ulearning_app/features/post/controller/post_filter_notifier.dart';
import 'package:ulearning_app/common/utils/network_error.dart';
import 'package:ulearning_app/common/utils/snackbar.dart';
import 'package:ulearning_app/features/post/view/widgets/search_filter_row.dart';
import 'package:ulearning_app/common/view_model/post_view_model.dart';
import 'package:ulearning_app/features/post/view/widgets/post_widget.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_empty_search.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_loading_spinner.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late PageController controller;

  PostsViewModel get viewModel => ref.read(postsViewModelProvider.notifier);

  PostFilterNotifier get filterController =>
      ref.read(postFilterNotifierProvider.notifier);

  @override
  void didChangeDependencies() {
    controller =
        PageController(initialPage: ref.watch(homeScreenBannerDotsProvider));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postsViewModelProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        context.showErrorSnackBar(state.dioException.errorMessage);
      }
    });
    final postsState = ref.watch(postsViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.axisDirection == AxisDirection.down &&
              scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
            if (viewModel.canLoadMore) {
              viewModel.loadNextPage();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            viewModel.refresh();
          },
          child: CustomScrollView(
            slivers: [
              HomeAppBar(
                filterProvider: postFilterNotifierProvider,
                onFilterChanged: (newFilter) {
                  filterController.update(newFilter);
                  applyFilter();
                },
              ),
              // SliverPadding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w),
              //   sliver: SliverToBoxAdapter(
              //     child: HomeBanner(ref: ref, controller: controller),
              //   ),
              // ),
              // SliverList(
              //     delegate: SliverChildListDelegate([
              //   Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const HelloText(),
              //       const UserName(),
              //       Center(
              //         child: HomeBanner(ref: ref, controller: controller),
              //       ),
              //     ],
              //   )
              // ])),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 16),
                sliver: SearchFilterRow(
                  onSearch: onSearch,
                ),
              ),
              ...posts(context, postsState),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> posts(BuildContext context, AsyncValue<List<Post>> postState) {
    final repositories = postState.valueOrNull ?? [];
    final initialLoading = postState.isLoading && repositories.isEmpty;
    final loadingMore = postState.isLoading && repositories.isNotEmpty;

    return initialLoading
        ? shimmerLoading()
        : repositories.isEmpty
            ? [const SliverEmptySearch(text: "No repositories found")]
            : [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        BeehavePostWidget(post: repositories[index]),
                    childCount: repositories.length,
                  ),
                ),
                if (loadingMore) const SliverLoadingSpinner(),
              ];
  }

  List<Widget> shimmerLoading() {
    return List.generate(10, (index) => const SliverListTileShimmer());
  }

  void applyFilter() {
    viewModel.applyFilter(ref.read(postFilterNotifierProvider));
  }

  void onSearch(String query) {
    filterController.updateQuery(query);
    applyFilter();
  }
}
