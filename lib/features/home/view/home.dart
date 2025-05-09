import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:beehive/features/home/view/widgets/home_widget.dart';
import 'package:beehive/features/post/controller/post_filter_notifier.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:beehive/common/utils/snackbar.dart';
import 'package:beehive/features/post/view/widgets/search_filter_row.dart';
import 'package:beehive/common/view_model/post_view_model.dart';
import 'package:beehive/features/post/view/widgets/post_widget.dart';
import 'package:beehive/features/post/view/widgets/sliver_empty_search.dart';
import 'package:beehive/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:beehive/features/post/view/widgets/sliver_loading_spinner.dart';

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
  void initState() {
    super.initState();
    controller = PageController(initialPage: ref.read(postBannerDotsProvider));
    viewModel.build();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postsViewModelProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        debugPrint("Erreur capturée : ${state.error}");
        final dioError = state.dioException;
        if (dioError != null) {
          context.showErrorSnackBar(dioError.errorMessage);
        } else {
          context.showErrorSnackBar("Erreur inattendue : ${state.error}");
        }
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
              viewModel.loadNextPage(); // Charge la prochaine page si possible
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            viewModel.refresh(); // Rafraîchit la liste des posts
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
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 16),
                sliver: SearchFilterRow(
                  onSearch: onSearch, // Applique le filtre de recherche
                ),
              ),
              ...posts(context, postsState),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour afficher les posts, y compris la gestion de la pagination et du cache
  List<Widget> posts(BuildContext context, AsyncValue<List<Post>> postState) {
    final repositories = postState.valueOrNull ?? [];
    final initialLoading = postState.isLoading && repositories.isEmpty;
    final loadingMore = postState.isLoading && repositories.isNotEmpty;

    // Only show the "No Posts found" message during initial loading when there are no posts
    // Don't show it when we've reached the end of the list
    if (initialLoading) {
      return shimmerLoading(); // Affiche une animation de chargement si les posts sont encore en cours de récupération
    } else if (repositories.isEmpty && !viewModel.canLoadMore) {
      // Si aucun post n'est disponible, essayer de charger depuis SharedPreferences
      return [
        FutureBuilder<List<Post>>(
          future: viewModel.getPostsFromLocalStorage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverLoadingSpinner();
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Afficher les posts depuis SharedPreferences
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => BeehavePostWidget(
                      post: snapshot.data![index]),
                  childCount: snapshot.data!.length,
                ),
              );
            } else {
              // Aucun post disponible, même dans SharedPreferences
              return const SliverEmptySearch(text: "No Posts found");
            }
          },
        )
      ];
    } else {
      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => BeehavePostWidget(
                post: repositories[index]), // Affiche chaque post
            childCount: repositories.length,
          ),
        ),
        if (loadingMore)
          const SliverLoadingSpinner(), // Affiche un spinner lors du chargement supplémentaire
      ];
    }
  }

  // Méthode pour afficher l'animation de chargement
  List<Widget> shimmerLoading() {
    return List.generate(10,
        (index) => const SliverListTileShimmer()); // Animation de chargement
  }

  // Applique le filtre pour charger les posts
  void applyFilter() {
    viewModel.applyFilter(ref.read(postFilterNotifierProvider));
  }

  // Applique le filtre de recherche
  void onSearch(String query) {
    filterController.updateQuery(query); // Met à jour la requête de recherche
    applyFilter();
  }
}
