// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AssetFileProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetFileHash() => r'a97216730a33b19964badb51b0a3746985dd01d8';

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

typedef AssetFileRef = AutoDisposeFutureProviderRef<ByteData>;

/// See also [assetFile].
@ProviderFor(assetFile)
const assetFileProvider = AssetFileFamily();

/// See also [assetFile].
class AssetFileFamily extends Family<AsyncValue<ByteData>> {
  /// See also [assetFile].
  const AssetFileFamily();

  /// See also [assetFile].
  AssetFileProvider call(
    String filePath,
  ) {
    return AssetFileProvider(
      filePath,
    );
  }

  @override
  AssetFileProvider getProviderOverride(
    covariant AssetFileProvider provider,
  ) {
    return call(
      provider.filePath,
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
  String? get name => r'assetFileProvider';
}

/// See also [assetFile].
class AssetFileProvider extends AutoDisposeFutureProvider<ByteData> {
  /// See also [assetFile].
  AssetFileProvider(
    this.filePath,
  ) : super.internal(
          (ref) => assetFile(
            ref,
            filePath,
          ),
          from: assetFileProvider,
          name: r'assetFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetFileHash,
          dependencies: AssetFileFamily._dependencies,
          allTransitiveDependencies: AssetFileFamily._allTransitiveDependencies,
        );

  final String filePath;

  @override
  bool operator ==(Object other) {
    return other is AssetFileProvider && other.filePath == filePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
