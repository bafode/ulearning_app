import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/auth/updateUserInfoRequest/update_user_info_request.dart';

class UpdateUserInfoNotifier extends StateNotifier<UpdateUserInfoRequest> {
  UpdateUserInfoNotifier() : super(UpdateUserInfoRequest());

  void onCityChangeChange(String city) {
    state = state.copyWith(city: city);
  }

  void onSchoolChange(String school) {
    state = state.copyWith(school: school);
  }

  void onFieldOfStudyChange(String fieldOfStudy) {
    state = state.copyWith(fieldOfStudy: fieldOfStudy);
  }

  void onLevelOfStudyChange(String levelOfStudy) {
    state = state.copyWith(levelOfStudy: levelOfStudy);
  }

  void onCategoriesChange(List<String>? categories) {
    state = state.copyWith(categories: categories);
  }
}

final updateUserInfoNotifierProvier =
    StateNotifierProvider<UpdateUserInfoNotifier, UpdateUserInfoRequest>(
        (ref) => UpdateUserInfoNotifier());
