// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FileTempProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileTempHash() => r'ab3d3252fa263dc77d4fb3122d54cc295a755c67';

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

typedef FileTempRef = AutoDisposeFutureProviderRef<File>;

/// See also [fileTemp].
@ProviderFor(fileTemp)
const fileTempProvider = FileTempFamily();

/// See also [fileTemp].
class FileTempFamily extends Family<AsyncValue<File>> {
  /// See also [fileTemp].
  const FileTempFamily();

  /// See also [fileTemp].
  FileTempProvider call(
    String bucketId,
    String id,
  ) {
    return FileTempProvider(
      bucketId,
      id,
    );
  }

  @override
  FileTempProvider getProviderOverride(
    covariant FileTempProvider provider,
  ) {
    return call(
      provider.bucketId,
      provider.id,
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
  String? get name => r'fileTempProvider';
}

/// See also [fileTemp].
class FileTempProvider extends AutoDisposeFutureProvider<File> {
  /// See also [fileTemp].
  FileTempProvider(
    this.bucketId,
    this.id,
  ) : super.internal(
          (ref) => fileTemp(
            ref,
            bucketId,
            id,
          ),
          from: fileTempProvider,
          name: r'fileTempProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fileTempHash,
          dependencies: FileTempFamily._dependencies,
          allTransitiveDependencies: FileTempFamily._allTransitiveDependencies,
        );

  final String bucketId;
  final String id;

  @override
  bool operator ==(Object other) {
    return other is FileTempProvider &&
        other.bucketId == bucketId &&
        other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bucketId.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
