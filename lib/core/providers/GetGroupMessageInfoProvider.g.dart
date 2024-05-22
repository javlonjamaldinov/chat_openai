// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetGroupMessageInfoProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getGroupMessageInfoHash() =>
    r'd19afe099116f0bd717afc5c9d3a6ddb76a35f0d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef GetGroupMessageInfoRef
    = AutoDisposeFutureProviderRef<GroupMessageInfoAppwrite?>;

/// See also [getGroupMessageInfo].
@ProviderFor(getGroupMessageInfo)
const getGroupMessageInfoProvider = GetGroupMessageInfoFamily();

/// See also [getGroupMessageInfo].
class GetGroupMessageInfoFamily
    extends Family<AsyncValue<GroupMessageInfoAppwrite?>> {
  /// See also [getGroupMessageInfo].
  const GetGroupMessageInfoFamily();

  /// See also [getGroupMessageInfo].
  GetGroupMessageInfoProvider call(
    GroupAppwrite group,
    String myUserId,
  ) {
    return GetGroupMessageInfoProvider(
      group,
      myUserId,
    );
  }

  @override
  GetGroupMessageInfoProvider getProviderOverride(
    covariant GetGroupMessageInfoProvider provider,
  ) {
    return call(
      provider.group,
      provider.myUserId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getGroupMessageInfoProvider';
}

/// See also [getGroupMessageInfo].
class GetGroupMessageInfoProvider
    extends AutoDisposeFutureProvider<GroupMessageInfoAppwrite?> {
  /// See also [getGroupMessageInfo].
  GetGroupMessageInfoProvider(
    this.group,
    this.myUserId,
  ) : super.internal(
          (ref) => getGroupMessageInfo(
            ref,
            group,
            myUserId,
          ),
          from: getGroupMessageInfoProvider,
          name: r'getGroupMessageInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getGroupMessageInfoHash,
          dependencies: GetGroupMessageInfoFamily._dependencies,
          allTransitiveDependencies:
              GetGroupMessageInfoFamily._allTransitiveDependencies,
        );

  final GroupAppwrite group;
  final String myUserId;

  @override
  bool operator ==(Object other) {
    return other is GetGroupMessageInfoProvider &&
        other.group == group &&
        other.myUserId == myUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, group.hashCode);
    hash = _SystemHash.combine(hash, myUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
