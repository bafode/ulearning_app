import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';

Widget text24Normal(
    {String text = "",
    Color color = AppColors.primaryText,
    FontWeight fontWeight = FontWeight.normal}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(color: color, fontSize: 24.sp, fontWeight: fontWeight),
  );
}

class Text13Normal extends StatelessWidget {
  final String? text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;

  const Text13Normal(
      {Key? key,
      this.text = "",
      this.color = AppColors.primaryText,
      this.fontWeight = FontWeight.bold,
      this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: 13.sp, fontWeight: fontWeight),
    );
  }
}

class Text16Normal extends StatelessWidget {
  final String? text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;

  const Text16Normal(
      {Key? key,
      this.text = "",
      this.color = AppColors.primarySecondaryElementText,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: 16.sp, fontWeight: fontWeight),
    );
  }
}

class Text14Normal extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight? fontWeight;

  const Text14Normal(
      {Key? key,
      this.text = "",
      this.color = AppColors.primaryThirdElementText,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(color: color, fontSize: 14.sp, fontWeight: fontWeight),
    );
  }
}

class Text11Normal extends StatelessWidget {
  final String? text;
  final Color color;

  const Text11Normal(
      {Key? key, this.text = "", this.color = AppColors.primaryElementText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: color, fontSize: 11.sp, fontWeight: FontWeight.normal),
    );
  }
}

class Text10Normal extends StatelessWidget {
  final String text;
  final Color color;

  const Text10Normal(
      {Key? key,
      this.text = "",
      this.color = AppColors.primaryThirdElementText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.clip,
      maxLines: 1,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: color, fontSize: 10.sp, fontWeight: FontWeight.normal),
    );
  }
}

Widget textUnderline({String text = "Your text"}) {
  return GestureDetector(
    onTap: () {},
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12.sp,
        color: AppColors.primaryText,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.primaryText,
      ),
    ),
  );
}

class FadeText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const FadeText(
      {super.key,
      this.text = "",
      this.color = AppColors.primaryElement,
      this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: false,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: TextStyle(
          color: color, fontSize: fontSize.sp, fontWeight: FontWeight.bold),
    );
  }
}

class PostText extends StatefulWidget {
  final String? text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;

  const PostText({
    super.key,
    this.text = "",
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
  });

  @override
  State createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        widget.text!,
        textAlign: TextAlign.justify,
        maxLines: isExpanded ? 100 : 2, // Show only 2 lines initially
        style: TextStyle(
          color: widget.color,
          fontSize: 14,
          fontWeight: widget.fontWeight,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
