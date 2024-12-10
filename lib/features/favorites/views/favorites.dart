import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/favorites/controller/controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/network_error.dart';
import 'package:ulearning_app/common/utils/snackbar.dart';
import 'package:ulearning_app/features/post/view/widgets/post_widget.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_empty_search.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:ulearning_app/features/post/view/widgets/sliver_loading_spinner.dart';

class Favorites extends ConsumerStatefulWidget {
  const Favorites({super.key});

  @override
  ConsumerState<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends ConsumerState<Favorites> {
  FavoriteController get controller =>
      ref.read(favoriteControllerProvider.notifier);

  @override
  void didChangeDependencies() {
    controller.build();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(favoriteControllerProvider, (_, state) {
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
    final postsState = ref.watch(favoriteControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.axisDirection == AxisDirection.down &&
              scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
            if (controller.canLoadMore) {
              controller.loadNextPage();
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            controller.refresh(); // Rafraîchit la liste des posts
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppColors.primaryElement,
                 leading: GestureDetector(
                  onTap: () =>
                      ref.read(appZoomControllerProvider).toggle?.call(),
                  child: const Icon(
                    Icons.menu,
                      size: 30,
                      color: Colors.white,
                      ),
                ),
                title: Text(
                  "Favoris",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
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

    return initialLoading
        ? shimmerLoading() // Affiche une animation de chargement si les posts sont encore en cours de récupération
        : repositories.isEmpty
            ? [
                const SliverEmptySearch(text: "No Favorite found")
              ] // Si aucune donnée n'est trouvée
            : [
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

  // Méthode pour afficher l'animation de chargement
  List<Widget> shimmerLoading() {
    return List.generate(10,
        (index) => const SliverListTileShimmer()); // Animation de chargement
  }
}
