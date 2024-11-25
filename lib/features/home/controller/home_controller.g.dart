// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeScreenBannerDotsHash() =>
    r'44c3f15bab8bacef82ebfe414b4828aab1c80408';

/// See also [HomeScreenBannerDots].
@ProviderFor(HomeScreenBannerDots)
final homeScreenBannerDotsProvider =
    NotifierProvider<HomeScreenBannerDots, int>.internal(
  HomeScreenBannerDots.new,
  name: r'homeScreenBannerDotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeScreenBannerDotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeScreenBannerDots = Notifier<int>;
String _$postBannerDotsHash() => r'33fede2f177709bc9357c580528a374f9f11aea5';

/// See also [PostBannerDots].
@ProviderFor(PostBannerDots)
final postBannerDotsProvider = NotifierProvider<PostBannerDots, int>.internal(
  PostBannerDots.new,
  name: r'postBannerDotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postBannerDotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostBannerDots = Notifier<int>;
String _$logoutHash() => r'2d158bb1efb7c3355237a807d75ea04e256c7027';

/// See also [Logout].
@ProviderFor(Logout)
final logoutProvider = AutoDisposeAsyncNotifierProvider<Logout, bool>.internal(
  Logout.new,
  name: r'logoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Logout = AutoDisposeAsyncNotifier<bool>;
String _$homeUserProfileHash() => r'59537d0f0f22908d6fa519f1eab208f9e77ce11a';

/// See also [HomeUserProfile].
@ProviderFor(HomeUserProfile)
final homeUserProfileProvider =
    AutoDisposeAsyncNotifierProvider<HomeUserProfile, User>.internal(
  HomeUserProfile.new,
  name: r'homeUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeUserProfile = AutoDisposeAsyncNotifier<User>;
String _$homePostListHash() => r'70fc3483940887048cd7e07960c05f4c9a479694';

/// See also [HomePostList].
@ProviderFor(HomePostList)
final homePostListProvider =
    AsyncNotifierProvider<HomePostList, List<Post>?>.internal(
  HomePostList.new,
  name: r'homePostListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homePostListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomePostList = AsyncNotifier<List<Post>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
