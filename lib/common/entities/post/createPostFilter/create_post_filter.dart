import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_filter.freezed.dart';

@freezed
class CreatePostFilter with _$CreatePostFilter {
  const factory CreatePostFilter({
    @Default([]) List<FieldOfStudy> fieldsOfStudy,
  }) = _CreatePostFilter;
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
  const DesignUiUx() : super('ui_ux', 'Design UI/UX');
}

class DA extends FieldOfStudy {
  const DA() : super('da', 'Direction Artistique');
}
