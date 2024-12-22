import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/unotification/notifiers/unotification_notifier.dart';

class Unotification extends ConsumerStatefulWidget {
  const Unotification({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Unotification());
  }

  @override
  ConsumerState<Unotification> createState() => _UnotificationPage();
}

class _UnotificationPage extends ConsumerState<Unotification> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unotificationProvider);
      return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 25.w,
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (content, index) {
                    return _buildListItem();
                  },
                  childCount: 6,
                )
            ),),
          SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 0.w),
              sliver:const SliverToBoxAdapter(
                child:Align(alignment: Alignment.center,child: Text('loading...'),),
              )
          ),
        ]),
      );
  }

  AppBar _buildAppBar() {
    return AppBar(
        title:  Container(
          child: Text(
            "Notification",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),);
  }

  Widget _buildListItem() {

    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(bottom: 20.h,),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset:
            const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
          onTap: () {

          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60.h,
                      child: Image(
                        image: const AssetImage("assets/icons/image(5).png"),
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 220.w,
                          margin: EdgeInsets.only(left:6.w),
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColors.primarySecondaryElementText,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left:6.w,top: 5.h),
                          child: Text(
                            "50 minutes ago",
                            style: TextStyle(
                              color: AppColors.primaryElement,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],)
                  ]),
              // 右侧
              Container(
                margin: EdgeInsets.only(top: 8.h),
                alignment:Alignment.topRight,
                child: Image(
                  image: const AssetImage("assets/icons/more-vertical-2.png"),
                  width: 16.w,
                  height: 16.h,
                ),
              )
            ],
          )),
    );
  }

}
