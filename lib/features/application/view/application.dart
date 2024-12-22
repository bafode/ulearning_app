import 'package:beehive/features/message/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/features/application/view/widgets/zoom.dart';
import 'package:get/get.dart';

class Application extends ConsumerStatefulWidget{
  const Application({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}
class ApplicationState extends ConsumerState<Application> {

  @override
  void initState() {
    super.initState();
    
    Get.lazyPut(() => MessageController());
  }

  @override
  Widget build(BuildContext context) {
    return const DrawerWidget();
  }
}
