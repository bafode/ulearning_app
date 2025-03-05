import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final IconData iconName;
  final String hintText;
  final bool obscureText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onChangeVisibility;

  const AppTextField({
    super.key,
    this.controller,
    this.text = "",
    this.iconName = Icons.person,
    this.hintText = "Type in your info",
    this.obscureText = false,
    this.validator,
    this.maxLines,
    this.onChanged,
    this.onChangeVisibility,
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
    return 
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
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
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                ),
                labelText: widget.text,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: _focusNode.hasFocus
                      ? Colors.black87
                      : Colors.black54,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black87.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black87.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _errorText != null ? Colors.red : Colors.black87,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    widget.onChangeVisibility != null
                    ? (widget.obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined)
                    : (widget.obscureText
                        ? Icons.lock_outline
                        : widget.iconName),
                    color: _focusNode.hasFocus ? Colors.black87 : Colors.black54,
                    size: 20.sp,
                  ),
                  onPressed: widget.onChangeVisibility,
                ),
                // suffixIcon: widget.onChangeVisibility != null
                //     ? IconButton(
                //         icon: Icon(
                //           widget.obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                //           color: _focusNode.hasFocus ? Colors.black87 : Colors.black54,
                //           size: 20.sp,
                //         ),
                //         onPressed: widget.onChangeVisibility,
                //       )
                //     : null,
                errorText: _errorText,
                errorStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.red.shade400,
                ),
              ),
              maxLines: widget.maxLines??1,
              autocorrect: false,
            ),
          ),
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
