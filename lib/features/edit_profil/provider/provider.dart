import 'package:beehive/common/entities/user/editProfileRequest/edit_profil_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilNotifier extends StateNotifier<EditProfilRequest> {
  EditProfilNotifier() : super(const EditProfilRequest());

  void onUserFirstNameChange(String firstName) {
    state = state.copyWith(firstname: firstName);
  }

  void onUserLastNameChange(String lastName) {
    
    state = state.copyWith(lastname: lastName);
  }

  void onUserDescriptionChange(String description) {
    state = state.copyWith(description: description);
    print(state.lastname);
    print(state.description);
    print(state.firstname);
  }
}

final editProfilNotifierProvier =
    StateNotifierProvider<EditProfilNotifier, EditProfilRequest>(
        (ref) => EditProfilNotifier());
