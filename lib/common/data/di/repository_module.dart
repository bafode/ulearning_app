import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/remote/rest_client_api.dart';
import 'package:ulearning_app/common/data/repository/impl/auth_repository_impl.dart';
import 'package:ulearning_app/common/data/repository/impl/post_repository_impl.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepositoryImpl(ref.watch(restClientApiProvider)));
final postRepositoryProvider =
    Provider((ref) => PostRepositoryImpl(ref.watch(restClientApiProvider)));
