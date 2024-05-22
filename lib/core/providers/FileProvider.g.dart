// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FileProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileHash() => r'66eeb540dbb54984f176b17f130dc81d824283f2';

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

typedef FileRef = AutoDisposeFutureProviderRef<File>;

/// See also [file].
@ProviderFor(file)
const fileProvider = FileFamily();

/// See also [file].
class FileFamily extends Family<AsyncValue<File>> {
  /// See also [file].
  const FileFamily();

  /// See also [file].
  FileProvider call(
    String bucketId,
    String id,
    String fileName,
  ) {
    return FileProvider(
      bucketId,
      id,
      fileName,
    );
  }

  @override
  FileProvider getProviderOverride(
    covariant FileProvider provider,
  ) {
    return call(
      provider.bucketId,
      provider.id,
      provider.fileName,
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
  String? get name => r'fileProvider';
}

/// See also [file].
class FileProvider extends AutoDisposeFutureProvider<File> {
  /// See also [file].
  FileProvider(
    this.bucketId,
    this.id,
    this.fileName,
  ) : super.internal(
          (ref) => file(
            ref,
            bucketId,
            id,
            fileName,
          ),
          from: fileProvider,
          name: r'fileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$fileHash,
          dependencies: FileFamily._dependencies,
          allTransitiveDependencies: FileFamily._allTransitiveDependencies,
        );

  final String bucketId;
  final String id;
  final String fileName;

  @override
  bool operator ==(Object other) {
    return other is FileProvider &&
        other.bucketId == bucketId &&
        other.id == id &&
        other.fileName == fileName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bucketId.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, fileName.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
