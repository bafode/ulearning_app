// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_nav_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationNavNotifierHash() =>
    r'132ddb91706f31dc8ddc0c9be4d08ab4a29cbe80';

/// See also [ApplicationNavNotifier].
@ProviderFor(ApplicationNavNotifier)
final applicationNavNotifierProvider =
    NotifierProvider<ApplicationNavNotifier, int>.internal(
  ApplicationNavNotifier.new,
  name: r'applicationNavNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$applicationNavNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApplicationNavNotifier = Notifier<int>;
String _$isLoggedInHash() => r'3a97746f3b8e35bd2262b03c2ced9fc7e8b05275';

/// See also [IsLoggedIn].
@ProviderFor(IsLoggedIn)
final isLoggedInProvider =
    AutoDisposeNotifierProvider<IsLoggedIn, bool>.internal(
  IsLoggedIn.new,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsLoggedIn = AutoDisposeNotifier<bool>;
String _$zoomIndexHash() => r'a3aaca954f46c0f2f6b17b6d5ec8e3738f6fc3cf';

/// See also [ZoomIndex].
@ProviderFor(ZoomIndex)
final zoomIndexProvider = AutoDisposeNotifierProvider<ZoomIndex, int>.internal(
  ZoomIndex.new,
  name: r'zoomIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$zoomIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ZoomIndex = AutoDisposeNotifier<int>;
String _$appZoomControllerHash() => r'ccba3d574f7c65f9841f2b70f91fc08edb1085ed';

/// See also [AppZoomController].
@ProviderFor(AppZoomController)
final appZoomControllerProvider = AutoDisposeNotifierProvider<AppZoomController,
    ZoomDrawerController>.internal(
  AppZoomController.new,
  name: r'appZoomControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appZoomControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppZoomController = AutoDisposeNotifier<ZoomDrawerController>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
