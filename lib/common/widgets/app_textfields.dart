import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final IconData iconName;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.text = "",
    this.iconName = Icons.person,
    this.hintText = "Type in your info",
    this.obscureText = false,
    this.validator,
    this.onChanged,
  });

  @override
  AppTextFieldState createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
  String? _errorText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Rafraîchit pour montrer le focus
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: (value) {
              _validate(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            obscureText: widget.obscureText,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
              labelText: widget.text,
              labelStyle: TextStyle(
                color: _focusNode.hasFocus
                    ? AppColors
                        .primaryElement // Couleur du label quand le champ est focus
                    : Colors.grey, // Couleur par défaut
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: AppColors.primaryElement, width: 0.1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryElement,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _errorText != null
                      ? Colors.red
                      : AppColors.primaryElement,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              suffixIcon: Icon(
                widget.iconName,
                color: AppColors.primaryElement,
                size: 20,
              ),
              errorText: _errorText,
            ),
            maxLines: 1,
            autocorrect: false,
          ),
        ),
      ],
    );
  }

  void validate() => _validate(widget.controller?.text);
}

Widget appTextFieldOnly({
  TextEditingController? controller,
  String hintText = "Type in your info",
  double width = 280,
  double height = 50,
  void Function(String value)? func,
  bool obscureText = false,
}) {
  return SizedBox(
    width: width.w,
    height: height.h,
    child: TextField(
      controller: controller,
      onChanged: (value) => func!(value),
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      maxLines: 1,
      autocorrect: false,
      obscureText: obscureText,
    ),
  );
}
