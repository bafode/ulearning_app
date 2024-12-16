import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_filter.freezed.dart';

@freezed
class PostFilter with _$PostFilter {
  const factory PostFilter({
    String? query,
    @Default([]) List<FieldOfStudy> fieldsOfStudy,
    SortOption? category,
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
  const CommunauteSort() : super('communaute', 'Communauté');
}

sealed class OrderOption {
  const OrderOption(this.value, this.label);

  final String value;
  final String label;
}

class NouveauteOrder extends OrderOption {
  const NouveauteOrder() : super('nouveaute', 'Nouveauté');
}

class PopulaireOrder extends OrderOption {
  const PopulaireOrder() : super('populaire', 'Populaire');
}

class DomainOrder extends OrderOption {
  const DomainOrder() : super('domaine', 'Domaine');
}

sealed class FieldOfStudy {
  const FieldOfStudy(this.value, this.label);

  final String value;
  final String label;
}

class Dev extends FieldOfStudy {
  const Dev() : super('dev', 'Dévéloppement');
}

class Marketing extends FieldOfStudy {
  const Marketing() : super('marketing', 'Marketing');
}

class DesignUiUx extends FieldOfStudy {
  const DesignUiUx() : super('design UI/UX', 'Design UI/UX');
}

class DA extends FieldOfStudy {
  const DA() : super('da', 'Direction Artistique');
}
