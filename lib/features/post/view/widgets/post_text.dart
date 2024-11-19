import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatefulWidget {
  final String content;

  const PostContent({required this.content, super.key});

  @override
  PostContentState createState() => PostContentState();
}

class PostContentState extends State<PostContent> {
  bool isExpanded = false;
  static const int textLimit = 100;

  @override
  Widget build(BuildContext context) {
    final displayText = isExpanded || widget.content.length <= textLimit
        ? widget.content
        : widget.content.substring(0, textLimit);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppColors.primarySecondaryElementText,
                fontSize: 14.sp,
                letterSpacing: 0.5,
                wordSpacing: 1,
              ),
              children: _buildTextSpans(displayText),
            ),
          ),
          if (!isExpanded && widget.content.length > textLimit)
            GestureDetector(
              onTap: () => setState(() => isExpanded = true),
              child: Text(
                'voir plus...',
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final linkRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    final spans = <TextSpan>[];
    final matches = linkRegExp.allMatches(text);

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(color: AppColors.primaryElement),
        recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
