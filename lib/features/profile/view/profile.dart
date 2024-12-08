import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/features/profile/controller/profile_controller.dart';
import 'package:ulearning_app/features/profile/view/profil_list_view.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<Profile>
    with SingleTickerProviderStateMixin {
  int post_lenght = 8;
  bool yourse = true;
  bool follow = false;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileControllerProvider);
    print(userProfile);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ProfileHeader(userProfile)),
              SliverToBoxAdapter(
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.grid_on),
                      ),
                      Tab(
                        icon: Icon(Icons.slow_motion_video),
                      ),
                      Tab(
                        icon: Icon(Icons.bookmark_border_outlined),
                      )
                    ],
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    // postState.when(
                    //   data: (data) {
                    //     return GridView.builder(
                    //       gridDelegate:
                    //           const SliverGridDelegateWithFixedCrossAxisCount(
                    //               crossAxisCount: 3),
                    //       itemBuilder: (context, index) {
                    //         return GestureDetector(
                    //           onTap: () {
                    //             // Navigator.of(context).push(MaterialPageRoute(
                    //             //     builder: (context) => PostScreen(snap.data(),),),);
                    //           },
                    //           child: CachedImage(
                    //             "${AppConstants.SERVER_API_URL}${data[index].media![0]}",
                    //           ),
                    //         );
                    //       },
                    //       itemCount: data!.length,
                    //     );
                    //   },
                    //   error: (error, stackTrace) {
                    //     return const SliverFillRemaining(
                    //         child: Center(child: Text("Error loading data")));
                    //   },
                    //   loading: () => const SliverFillRemaining(
                    //     child: Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //   ),
                    // ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(1.5),
                          height: 500,
                          width: 500,
                          color: Colors.grey.shade200,
                        );
                      },
                      itemCount: 8,
                    ),

                    //reals
                    const Icon(
                      Icons.slow_motion_video,
                      size: 50,
                    ),
                    //tag
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(1.5),
                          height: 500,
                          width: 500,
                          color: Colors.grey.shade200,
                        );
                      },
                      itemCount: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ProfileHeader(User user) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CachedImage(user.avatar == "default.jpg"
                        ? "${AppConstants.SERVER_API_URL}${user.avatar}"
                        : "${user.avatar}"),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 35.w),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 53.w),
                      Text(
                        "${user.followers?.length??"0"}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 70.w),
                      Text(
                        "${user.following?.length??"0"}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 19.w),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstname} ${user.lastname ?? ''}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  user.description ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: const ProfileListView(),
          ),
          SizedBox(height: 10.h),
          Visibility(
            visible: !follow && !yourse,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: GestureDetector(
                onTap: () {
                  // if (yourse == false) {
                  //   Firebase_Firestor().flollow(uid: widget.Uid);
                  //   setState(() {
                  //     follow = true;
                  //   });
                  // }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yourse ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color: yourse ? Colors.grey.shade400 : Colors.blue),
                  ),
                  child: yourse
                      ? const Text('Edit Your Profile')
                      : const Text(
                          'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Firebase_Firestor().flollow(uid: widget.Uid);
                        // setState(() {
                        //   follow = false;
                        // });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text('Unfollow'),
                      ),
                    ),
                  ),
                  // SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Text(
                        'Message',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 78,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.grey)),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        radius: 25,
                        child: const Icon(
                          Icons.add,
                          size: 17,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text('highlights'))
                  ],
                );
              },
              itemCount: 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
