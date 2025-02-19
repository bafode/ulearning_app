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
  const Dev() : super('dev', 'Développement');
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

class WebDev extends FieldOfStudy {
  const WebDev() : super('web_dev', 'Développement Web');
}

class MobileDev extends FieldOfStudy {
  const MobileDev() : super('mobile_dev', 'Développement Mobile');
}

class DataScience extends FieldOfStudy {
  const DataScience() : super('data_science', 'Data Science');
}

class AI extends FieldOfStudy {
  const AI() : super('ai', 'Intelligence Artificielle');
}

class GraphicDesign extends FieldOfStudy {
  const GraphicDesign() : super('graphic_design', 'Design Graphique');
}

class ProductDesign extends FieldOfStudy {
  const ProductDesign() : super('product_design', 'Design Produit');
}

class DigitalMarketing extends FieldOfStudy {
  const DigitalMarketing() : super('digital_marketing', 'Marketing Digital');
}

class ContentStrategy extends FieldOfStudy {
  const ContentStrategy() : super('content_strategy', 'Stratégie de Contenu');
}

class ProjectManagement extends FieldOfStudy {
  const ProjectManagement() : super('project_management', 'Gestion de Projet');
}

class BusinessStrategy extends FieldOfStudy {
  const BusinessStrategy() : super('business_strategy', 'Stratégie d\'Entreprise');
}

class Communication extends FieldOfStudy {
  const Communication() : super('communication', 'Communication');
}
