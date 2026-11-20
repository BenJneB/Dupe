// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_collection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The whole live collection, watched once for the screens that compute
/// over all of it (statistics, quality): one pair of queries per change,
/// not one per screen or section.

@ProviderFor(liveCollection)
final liveCollectionProvider = LiveCollectionProvider._();

/// The whole live collection, watched once for the screens that compute
/// over all of it (statistics, quality): one pair of queries per change,
/// not one per screen or section.

final class LiveCollectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<LiveCollection>,
          LiveCollection,
          Stream<LiveCollection>
        >
    with $FutureModifier<LiveCollection>, $StreamProvider<LiveCollection> {
  /// The whole live collection, watched once for the screens that compute
  /// over all of it (statistics, quality): one pair of queries per change,
  /// not one per screen or section.
  LiveCollectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveCollectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveCollectionHash();

  @$internal
  @override
  $StreamProviderElement<LiveCollection> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LiveCollection> create(Ref ref) {
    return liveCollection(ref);
  }
}

String _$liveCollectionHash() => r'e0e2c41245feae3eeee990d10021a4fbe6586cd7';
