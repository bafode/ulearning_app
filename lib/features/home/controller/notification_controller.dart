import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/features/message/state.dart';
import 'package:get/get.dart';

final notificationCountProvider = Provider.autoDispose<int>((ref) {
  try {
    final messageState = Get.find<MessageState>();
    
    // Create a stream that updates when either list changes
    final stream = Stream.periodic(const Duration(milliseconds: 100), (_) {
      // Count unread messages
      int messageCount = messageState.msgList
          .fold(0, (sum, message) => sum + (message.msg_num ?? 0));
      
      // Count calls
      int callCount = messageState.callList.length;
      
      return messageCount + callCount;
    });
    
    // Set up a listener to dispose
    ref.onDispose(() {
      stream.drain();
    });
    
    // Return current count
    int messageCount = messageState.msgList
        .fold(0, (sum, message) => sum + (message.msg_num ?? 0));
    int callCount = messageState.callList.length;
    return messageCount + callCount;
    
  } catch (e) {
    // Return 0 if MessageState is not initialized
    return 0;
  }
});
