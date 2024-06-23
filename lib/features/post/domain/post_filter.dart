import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_filter.freezed.dart';

@freezed
class PostFilter with _$PostFilter {
  const factory PostFilter({
    String? query,
    @Default([]) List<FieldOfStudy> fieldsOfStudy,
    SortOption? sort,
    OrderOption? order,
  }) = _PostFilter;
}

sealed class SortOption {
  const SortOption(this.value, this.label);

  final String value;
  final String label;
}

class InspirationSort extends SortOption {
  const InspirationSort() : super('inspiration', 'Inspiration');
}

class CommunauteSort extends SortOption {
  const CommunauteSort() : super('communaute', 'Communaute');
}

sealed class OrderOption {
  const OrderOption(this.value, this.label);

  final String value;
  final String label;
}

class LatestOrder extends OrderOption {
  const LatestOrder() : super('latest', 'Latest');
}

class PopularOrder extends OrderOption {
  const PopularOrder() : super('popular', 'Popular');
}

class DomainOrder extends OrderOption {
  const DomainOrder() : super('domaine', 'Domaine');
}

sealed class FieldOfStudy {
  const FieldOfStudy(this.value, this.label);

  final String value;
  final String label;
}

class Science extends FieldOfStudy {
  const Science() : super('science', 'Science');
}

class Technologie extends FieldOfStudy {
  const Technologie() : super('technologie', 'Technologie');
}

class Environnement extends FieldOfStudy {
  const Environnement() : super('environnement', 'Environnement');
}

class Sante extends FieldOfStudy {
  const Sante() : super('santé', 'Santé');
}

class Art extends FieldOfStudy {
  const Art() : super('art', 'Art');
}

class Ingenerie extends FieldOfStudy {
  const Ingenerie() : super('ingénerie', 'Ingénerie');
}

class Politique extends FieldOfStudy {
  const Politique() : super('politique', 'Politique');
}

class Commerce extends FieldOfStudy {
  const Commerce() : super('commerce', 'Commerce');
}

class UiUx extends FieldOfStudy {
  const UiUx() : super('ui/ux', 'UI/UX');
}

class Graphisme extends FieldOfStudy {
  const Graphisme() : super('graphisme', 'Graphisme');
}

class Dev extends FieldOfStudy {
  const Dev() : super('dev', 'Dev');
}

class Marketing extends FieldOfStudy {
  const Marketing() : super('marketing', 'Marketing');
}
