import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/features/sign_up/controller/sign_up_controller.dart';
import 'package:ulearning_app/features/sign_up/provider/update_user_info_notifier.dart';

class UpdateUserInfoForm extends ConsumerStatefulWidget {
  const UpdateUserInfoForm({super.key});

  @override
  UpdateUserInfoFormState createState() => UpdateUserInfoFormState();
}

class UpdateUserInfoFormState extends ConsumerState<UpdateUserInfoForm> {
  late SignUpController _controller;

  @override
  void initState() {
    _controller = SignUpController(ref: ref);
    super.initState();
  }

  final TextEditingController cityController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController levelOfStudyController = TextEditingController();

  String? validateVille(String? value) {
    if (value == null || value.isEmpty) {
      return 'La ville est requis';
    } else if (value.length < 3) {
      return 'La ville doit contenir au moins 3 lettres';
    }
    return null;
  }

  String? validateSchool(String? value) {
    if (value == null || value.isEmpty) {
      return "l'école est requise";
    } else if (value.length < 3) {
      return "L'école doit contenir au moins 3 lettres";
    }
    return null;
  }

  String? validateFieldOfStudy(String? value) {
    if (value == null || value.isEmpty) {
      return "Domaine d'étude est requise";
    } else if (value.length < 3) {
      return "Domaine d'étude doit contenir au moins 3 lettres";
    }
    return null;
  }

  String? validateLevelOfStudy(String? value) {
    if (value == null || value.isEmpty) {
      return "Niveau d'étude est requise";
    } else if (value.length < 3) {
      return "Niveau d'étude doit contenir au moins 3 lettres";
    }
    return null;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> categories = [
    {'label': 'DA', 'icon': Icons.brush},
    {'label': 'Marketing', 'icon': Icons.mark_email_read},
    {'label': 'Dév', 'icon': Icons.code},
    {'label': 'UI/UX', 'icon': Icons.design_services},
  ];
  List<bool> selectedCategories = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            AppTextField(
              controller: cityController,
              text: "Ville",
              iconName: Icons.location_city,
              hintText: "Entrez votre ville",
              validator: (value) => validateVille(value),
              onChanged: (value) => ref
                  .read(updateUserInfoNotifierProvier.notifier)
                  .onCityChangeChange(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: schoolController,
              text: "École",
              iconName: Icons.school,
              hintText: "Entrez le nom de votre école",
              validator: (value) => validateSchool(value),
              onChanged: (value) => ref
                  .read(updateUserInfoNotifierProvier.notifier)
                  .onSchoolChange(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: fieldOfStudyController,
              text: "Domaine d'étude",
              iconName: Icons.book,
              hintText: "Entrez votre domaine d'étude",
              validator: (value) => validateFieldOfStudy(value),
              onChanged: (value) => ref
                  .read(updateUserInfoNotifierProvier.notifier)
                  .onFieldOfStudyChange(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: levelOfStudyController,
              text: "Niveau d'étude",
              iconName: Icons.school,
              hintText: "Entrez votre niveau d'étude",
              validator: (value) => validateLevelOfStudy(value),
              onChanged: (value) => ref
                  .read(updateUserInfoNotifierProvier.notifier)
                  .onLevelOfStudyChange(value),
            ),
            const SizedBox(height: 16),
            _buildCategorySelection(ref),
            const SizedBox(height: 16),
            Center(
              child: AppButton(
                buttonName: "Update Info",
                isLogin: true,
                context: context,
                func: () async {
                  if (_formKey.currentState!.validate()) {
                    await _controller.updateUserInfo();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection(WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ajustez le nombre de colonnes en fonction de la largeur de l'écran
        int crossAxisCount = constraints.maxWidth > 600
            ? 6
            : 4; // 4 colonnes sur petits écrans, 6 colonnes sur grands écrans
        double iconSize = constraints.maxWidth > 600
            ? 60
            : 49; // Icônes plus grandes sur les écrans larges

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sélectionnez des catégories :",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategories[index] = !selectedCategories[index];
                      });
                      List<String>? selected = [];

                      for (int i = 0; i < categories.length; i++) {
                        if (selectedCategories[i]) {
                          selected.add(categories[i]['label']);
                        }
                      }
                      ref
                          .read(updateUserInfoNotifierProvier.notifier)
                          .onCategoriesChange(selected);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: selectedCategories[index]
                                ? AppColors.primaryElement
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Icon(
                            categories[index]['icon'],
                            size: iconSize,
                            color: selectedCategories[index]
                                ? Colors.white
                                : AppColors.primaryElement,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          categories[index]['label'],
                          style: TextStyle(
                            color: selectedCategories[index]
                                ? AppColors.primaryElement
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
