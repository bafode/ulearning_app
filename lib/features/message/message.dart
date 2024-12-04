import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';

import 'package:ulearning_app/common/models/message.dart' as MessageEntitie;
import 'package:ulearning_app/common/utils/date.dart';
import 'package:ulearning_app/features/message/message_logic.dart';
import 'package:ulearning_app/features/message/notifiers/message_notifier.dart';

class Message extends ConsumerStatefulWidget {
  const Message({super.key});


  @override
  ConsumerState<Message> createState() => _MessagePage();
}

class _MessagePage extends ConsumerState<Message> {
  late MessageLogic messageLogic;
  @override
  void initState() {
    super.initState();
    messageLogic = MessageLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      messageLogic.init();
    });
  }


  @override
  void didUpdateWidget(covariant Message oldWidget) {
    print("didUpdateWidget-------");
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose-------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);
      return WillPopScope(
        child:Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: state.loadStatus
            ? const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.black26, strokeWidth: 2)),
        )
            : CustomScrollView(slivers: [
         SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0.h,
              horizontal: 25.w,
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (content, index) {
                       var item = state.message.elementAt(index);
                    return _buildListItem(content,item);
                  },
                  childCount: state.message.length,
                )
            ),),
        ]),
      ),
      onWillPop: () async {
        print("onWillPop----");
        return false;
      },
      );

  }

  AppBar _buildAppBar() {
    return AppBar(
        title: Container(
          margin: EdgeInsets.only(left: 7.w, right: 7.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 18.w,
                height: 12.h,
                child: Image.asset("assets/icons/menu.png"),
              ),
              Container(
                child: Text(
                  "Message",
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
          GestureDetector(
            child:SizedBox(
                width: 24.w,
                height: 24.h,
                child: Image.asset("assets/icons/bell.png"),
              ),
              onTap:(){
       // Navigator.of(context).pushNamed(AppRoutes.Unotification);
        },
        )
            ],
          ),
        ));
  }

  Widget _searchView(BuildContext context, state) {
    return  Container(
      width: 325.w,
      height: 40.h,
      margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
      padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
      decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(15.h)),
          border: Border.all(color: AppColors.primaryFourthElementText)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w),
            padding: EdgeInsets.only(left: 0.w, top: 0.w),
            width: 16.w,
            height: 16.w,
            child: Image.asset("assets/icons/search.png"),
          ),
          SizedBox(
            width: 240.w,
            height: 40.h,
            child: TextField(
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                  color: AppColors.primaryThirdElementText,
                ),
                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColors.primaryText,
                fontFamily: "Avenir",
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
              ),
              onChanged: (value) {
                // controller.state.email.value = value;
              },
              maxLines: 1,
              autocorrect: false, // 自动纠正
              obscureText: false, // 隐藏输入内容, 密码框
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.only(left: 0.w, top: 0.w),
            width: 16.w,
            height: 16.w,
            child: Image.asset("assets/icons/mic.png"),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context,MessageEntitie.Message item) {

    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(bottom: 0.h,),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
      child: InkWell(
          onTap: () {
            messageLogic.goChat(item);
          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${item.avatar}"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.h)),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 210.w,
                          margin: EdgeInsets.only(left:10.w),
                          child: Text(
                            "${item.name}",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 210.w,
                          margin: EdgeInsets.only(left:10.w,top: 10.h),
                          child: Text(
                            "${item.last_msg}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryThirdElementText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],)
                  ]),
              // 右侧
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment:Alignment.center,
                    child: Text(
                      item.last_time == null
                            ? ""
                            : duTimeLineFormat(
                            (item.last_time as Timestamp).toDate()),
                      style: TextStyle(
                        color: AppColors.primaryThirdElementText,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  item.msg_num==0?Container():Container(
                    height: 15.h,
                    constraints: BoxConstraints(minWidth: 15.w),
                    decoration: BoxDecoration(
                        color: AppColors.primaryElement,
                        borderRadius: BorderRadius.all(Radius.circular(6.h)),),
                    alignment:Alignment.center,
                    child: Text(
                      "${item.msg_num}",
                      style: TextStyle(
                        color: AppColors.primaryElementText,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

}
