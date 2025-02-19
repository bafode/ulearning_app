import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/data/remote/rest_client_api.dart';
import 'package:beehive/common/data/repository/auth_repository.dart';
import 'package:beehive/common/data/repository/chat_repository.dart';
import 'package:beehive/common/data/repository/contact_repository.dart';
import 'package:beehive/common/data/repository/post_repository.dart';
import 'package:beehive/common/data/repository/impl/auth_repository_impl.dart';
import 'package:beehive/common/data/repository/impl/chat_repository_impl.dart';
import 'package:beehive/common/data/repository/impl/contact_repository_impl.dart';
import 'package:beehive/common/data/repository/impl/post_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(restClientApiProvider)),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(ref.watch(restClientApiProvider)),
);

final contactRepositoryProvider = Provider<ContactRepository>(
  (ref) => ContactRepositoryImpl(ref.watch(restClientApiProvider)),
);

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepositoryImpl(ref.watch(restClientApiProvider)),
);
