import 'package:flutter/material.dart';

class UpdateUserInfoForm extends StatefulWidget {
  const UpdateUserInfoForm({super.key});

  @override
  UpdateUserInfoFormState createState() => UpdateUserInfoFormState();
}

class UpdateUserInfoFormState extends State<UpdateUserInfoForm> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController levelOfStudyController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> categories = [
    {'label': 'Direction Artistique', 'icon': Icons.brush},
    {'label': 'Marketing Digital', 'icon': Icons.mark_email_read},
    {'label': 'Développement', 'icon': Icons.code},
    {'label': 'UI/UX Design', 'icon': Icons.design_services},
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
            _buildTextField(cityController, "Ville", Icons.location_city,
                "Entrez votre ville"),
            const SizedBox(height: 16),
            _buildTextField(schoolController, "École", Icons.school,
                "Entrez le nom de votre école"),
            const SizedBox(height: 16),
            _buildTextField(fieldOfStudyController, "Domaine d'étude",
                Icons.book, "Entrez votre domaine d'étude"),
            const SizedBox(height: 16),
            _buildTextField(levelOfStudyController, "Niveau d'étude",
                Icons.grade, "Entrez votre niveau d'étude"),
            const SizedBox(height: 16),
            _buildCategorySelection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Mettre à jour les informations"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sélectionnez des catégories :",
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.width < 600
              ? 150
              : 200, // Responsive height
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
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
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: selectedCategories[index]
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(categories[index]['icon'],
                              size: 40,
                              color: selectedCategories[index]
                                  ? Colors.white
                                  : Colors.black),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   categories[index]['label'],
                    //   style: TextStyle(
                    //     color: selectedCategories[index]
                    //         ? Colors.blue
                    //         : Colors.black,
                    //   ),
                    // ),
                     Column(
                      children: (categories[index]['label'] as String)
                          .split(' ')
                          .map((word) => Text(
                                word,
                                style: TextStyle(
                                  color: selectedCategories[index]
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String city = cityController.text;
      String school = schoolController.text;
      String fieldOfStudy = fieldOfStudyController.text;
      String levelOfStudy = levelOfStudyController.text;
      List<String> selected = [];

      for (int i = 0; i < categories.length; i++) {
        if (selectedCategories[i]) {
          selected.add(categories[i]['label']);
        }
      }

      // Affiche les informations collectées
      print(
          'Ville: $city, École: $school, Domaine d\'étude: $fieldOfStudy, Niveau d\'étude: $levelOfStudy, Catégories sélectionnées: $selected');
    }
  }
}
