
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChatLeftList extends StatelessWidget {
 const ChatLeftList({super.key,required this.item});
  final Msgcontent item;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250.w, minHeight: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(5.w))),
                    padding: EdgeInsets.only(
                        top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
                    child: item.type == "text"
                        ? Text(
                            "${item.content}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryElementText),
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 90.w),
                            child: GestureDetector(
                              child: CachedNetworkImage(
                                imageUrl: item.content!,
                              ),
                              onTap: () {},
                            ),
                          ))
              ],
            ),
          )
        ],
      ),
    );
  }

}