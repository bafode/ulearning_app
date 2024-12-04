import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/date.dart';
import 'package:ulearning_app/features/message/chat/chat_logic.dart';
import 'package:ulearning_app/features/message/chat/notifiers/chat_notifier.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatPage();
}

class _ChatPage extends ConsumerState<Chat> {
  late ChatLogic chatLogic;
  @override
  void initState() {
    super.initState();
    print("--------initState");
    chatLogic = ChatLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      chatLogic.init();
    });
  }

  @override
  void dispose() {
    chatLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(chatProvider);
          return Container(
              color: Colors.white,
              child: SafeArea(
              child: Scaffold(
              appBar: _buildAppBar(context, state),
              backgroundColor: Colors.white,
              body: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 70.h),
                            child: CustomScrollView(
                                reverse: true,
                                controller: chatLogic.myscrollController,
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0.w,
                                      horizontal: 25.w,
                                    ),
                                    sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                      (content, index) {
                                        var item = state.msgcontentList[index];
                                        if (chatLogic.userProfile.id ==
                                            item.token) {
                                          return ChatRightItem(item);
                                        }
                                        return ChatLeftItem(item);
                                      },
                                      childCount: state.msgcontentList.length,
                                    )),
                                  ),
                                  SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.w, horizontal: 0.w),
                                      sliver: SliverToBoxAdapter(
                                        child: state.isloading
                                            ? const Align(
                                                alignment: Alignment.center,
                                                child: Text('loading...'),
                                              )
                                            : Container(),
                                      )),
                                ]),
                          ),
                          onTap: () {
                            chatLogic.close_all_pop();
                          }),
                  Positioned(
                    bottom: 0.h,
                    child: Container(
                      width: 360.w,
                      constraints:
                          BoxConstraints(maxHeight: 170.h, minHeight: 70.h),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, bottom: 10.h, top: 10.h),
                      color: AppColors.primaryBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 270.w,
                              constraints: BoxConstraints(
                                  maxHeight: 170.h, minHeight: 50.h),
                              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBackground,
                                border: Border.all(
                                    color: AppColors.primarySecondaryBackground),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(children: [
                                Container(
                                  width: 220.w,
                                  padding: EdgeInsets.only(top: 5.h),
                                  constraints: BoxConstraints(
                                      maxHeight: 150.h, minHeight: 30.h),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: chatLogic.myinputController,
                                    autofocus: false,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      hintText: "Message...",
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 10.w, top: 0, bottom: 0),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors
                                            .primarySecondaryElementText,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 40.w,
                                    height: 40.h,
                                    alignment: Alignment.centerRight,
                                    child: Image.asset("assets/icons/05.png"),
                                  ),
                                  onTap: () {
                                    chatLogic.goMore();
                                  },
                                )
                              ])),
                          GestureDetector(
                              child: Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryElement,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.w)),
                                  ),
                                  child: Image.asset("assets/icons/send2.png")),
                              onTap: () {
                                chatLogic.sendMessage();
                              }),
                        ],
                      ),
                    ),
                  ),
                  state.more_status
                      ? Positioned(
                          right: 82.w,
                          bottom: 70.h,
                          height: 100.w,
                          width: 40.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.w)),
                                    ),
                                    child:
                                        Image.asset("assets/icons/file.png")),
                                onTap: () {
                                  chatLogic.imgFromGallery();
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.w)),
                                    ),
                                    child:
                                        Image.asset("assets/icons/photo.png")),
                                onTap: () {
                                  chatLogic.imgFromCamera();
                                },
                              ),
                            ],
                          ))
                      : Container()
                ]),
              ))));

  }

  AppBar _buildAppBar(BuildContext context, ChatState state) {
    return AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: AppColors.primarySecondaryBackground,
              height: 1.0,
            )),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(state.to_avatar),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            state.to_name,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, top: 0.h),
                          child: Text(
                            state.to_online == "1" ? "online" : "off-line",
                            style: TextStyle(
                              color: AppColors.primaryFourthElementText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
              // 右侧
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 25.w,
                      height: 25.h,
                      margin: EdgeInsets.only(right: 15.w),
                      child: const Image(
                        image: AssetImage("assets/icons/video(2).png"),
                      ),
                    ),
                    onTap: () {
                      chatLogic.goVideoCall();
                    },
                  ),
                  GestureDetector(
                    child: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: const Image(
                          image: AssetImage("assets/icons/phone-call.png"),
                        )),
                    onTap: () {
                      chatLogic.goVoiceCall();
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget ChatLeftItem(Msgcontent item) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 0.w, right: 20.w, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: 250.w, //
                  minHeight: 40.w //
                  ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.w, top: 0.w),
                      padding: EdgeInsets.only(
                          top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primarySecondaryBackground,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.w),
                            topRight: Radius.circular(20.w),
                            bottomRight: Radius.circular(20.w),
                            bottomLeft: Radius.circular(20.w)),
                      ),
                      child: item.type == "text"
                          ? Text("${item.content}",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.primaryText))
                          : ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 90.w),
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                    imageUrl: "${item.content}"),
                                onTap: () {
                                  chatLogic.photoImg(item);
                                },
                              )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      child: Text(
                          item.addtime == null
                              ? ""
                              : duTimeLineFormat(
                                  (item.addtime as Timestamp).toDate()),
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.primarySecondaryElementText)),
                    )
                  ])),
        ],
      ),
    );
  }

  Widget ChatRightItem(Msgcontent item) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 20.w, right: 0.w, bottom: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: 250.w, //
                  minHeight: 40.w //
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 0.w, top: 0.w),
                    padding: EdgeInsets.only(
                        top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          topRight: Radius.circular(0.w),
                          bottomRight: Radius.circular(20.w),
                          bottomLeft: Radius.circular(20.w)),
                    ),
                    child: item.type == "text"
                        ? Text("${item.content}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryElementText))
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 90.w, //
                            ),
                            child: GestureDetector(
                              child: CachedNetworkImage(
                                  imageUrl: "${item.content}"),
                              onTap: () {
                                chatLogic.photoImg(item);
                              },
                            )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Text(
                        item.addtime == null
                            ? ""
                            : duTimeLineFormat(
                                (item.addtime as Timestamp).toDate()),
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.primarySecondaryElementText)),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
