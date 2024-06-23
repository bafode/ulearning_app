import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

final sortOptionsProvider = Provider<List<SortOption>>(
    (ref) => ref.watch(postRepositoryProvider).fetchSortOptions());

final orderOptionsProvider = Provider<List<OrderOption>>(
    (ref) => ref.watch(postRepositoryProvider).fetchOrderOptions());

final fieldOfStudyProvider = Provider<List<FieldOfStudy>>(
    (ref) => ref.watch(postRepositoryProvider).fetchFieldOfStudy());

final postRepositoryProvider = Provider((ref) => PostQueryRepository());

class PostQueryRepository {
  List<SortOption> fetchSortOptions() {
    return [const InspirationSort(), const CommunauteSort()];
  }

  List<OrderOption> fetchOrderOptions() {
    return [const LatestOrder(), const DomainOrder(), const PopularOrder()];
  }

  List<FieldOfStudy> fetchFieldOfStudy() {
    return [
      const Science(),
      const Technologie(),
      const Art(),
      const Sante(),
      const Environnement(),
      const Ingenerie(),
      const Politique(),
      const UiUx(),
      const Commerce(),
      const Graphisme(),
      const Dev(),
      const Marketing()
    ];
  }
}
