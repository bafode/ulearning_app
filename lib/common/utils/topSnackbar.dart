import 'package:beehive/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/constants.dart';

class TopSnackbar extends StatefulWidget {
  const TopSnackbar({super.key});

  @override
  TopSnackbarState createState() => TopSnackbarState();
}

class TopSnackbarState extends State<TopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _position;
  bool _isShow = false;
  String _toFirstName = "";
  String _toLastName = "";
  String _toToken = "";
  String _toAvatar = "";
  String _docId = "";
  String _callRole = "";
  String _title = "";
  String _routeName = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _position = Tween<Offset>(begin: const Offset(0.0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show(String toFirstName,String toLastName, String toToken, String toAvatar,
      String docId, String callRole, String title, String routeName) {
    _isShow = true;
    setState(() {
      _toFirstName = toFirstName;
      _toLastName = toLastName;
      _toToken = toToken;
      _toAvatar = toAvatar;
      _docId = docId;
      _callRole = callRole;
      _title = title;
      _routeName = routeName;
    });
    return _animationController.forward();
  }

  bool isShow() {
    return _isShow;
  }

  hide() async {
    _isShow = false;
    _animationController.reverse();
    setState(() {
      _toFirstName = "";
      _toLastName = "";
      _toToken = "";
      _toAvatar = "";
      _docId = "";
      _callRole = "";
      _title = "";
      _routeName = "";
    });
  }

  _sendNotifications(String callType, String toToken, String toAvatar,
      String toFirstName, String toLastName, String docId) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;
    callRequestEntity.to_token = toToken;
    callRequestEntity.to_avatar = toAvatar;
    callRequestEntity.doc_id = docId;
    callRequestEntity.to_firstname = toFirstName;
    callRequestEntity.to_lastname = toLastName;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    if (res.code == 0) {
      print("sendNotifications success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            return Stack(alignment: Alignment.topCenter, children: <Widget>[
              SlideTransition(
                  position: _position,
                  child: GestureDetector(
                    onPanEnd: (DragEndDetails e) {
                      if (e.velocity.pixelsPerSecond.dy < -50) {
                        hide();
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: 340.w,
                      height: 70.w,
                      margin: EdgeInsets.only(top: 40.h),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    height: 70.w,
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${AppConstants.IMAGE_UPLOADS_PATH}default.png"),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.h)),
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 135.w,
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        "$_toFirstName $_toLastName",
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppColors.primaryText,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 135.w,
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        "Video Call",
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color:
                                              AppColors.primaryThirdElementText,
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
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 40.w,
                                  height: 40.w,
                                  padding: EdgeInsets.all(10.w),
                                  margin:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryElementBg,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.w)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child:
                                      Image.asset("assets/icons/a_phone.png"),
                                ),
                                onTap: () {
                                  hide();
                                  _sendNotifications("cancel", _toToken,
                                      _toAvatar, _toFirstName,_toLastName, _docId);
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 40.w,
                                  height: 40.w,
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryElementStatus,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.w)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                      "assets/icons/a_telephone.png"),
                                ),
                                onTap: () {
                                  if (Global.navigatorKey.currentContext != null) {
                                    Navigator.of(Global.navigatorKey
                                            .currentContext!)
                                        .pushNamed(_routeName, arguments: {
                                      "to_token": _toToken,
                                      "to_firstname": _toFirstName,
                                      "to_lastname": _toLastName,
                                      "to_avatar": _toAvatar,
                                      "doc_id": _docId,
                                      "call_role": _callRole
                                    });
                                  }
                                  hide();
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
            ]);
          },
        ),
      ],
    );
  }
}
