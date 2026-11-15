// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_checker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storeChecker)
final storeCheckerProvider = StoreCheckerProvider._();

final class StoreCheckerProvider
    extends $FunctionalProvider<StoreChecker, StoreChecker, StoreChecker>
    with $Provider<StoreChecker> {
  StoreCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeCheckerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeCheckerHash();

  @$internal
  @override
  $ProviderElement<StoreChecker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoreChecker create(Ref ref) {
    return storeChecker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreChecker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreChecker>(value),
    );
  }
}

String _$storeCheckerHash() => r'7587dc66d3510dcb13b6d89140318db15b94842e';

/// Store-mode result for a scanned ISBN; [type] is the tab scanned from.

@ProviderFor(storeCheck)
final storeCheckProvider = StoreCheckFamily._();

/// Store-mode result for a scanned ISBN; [type] is the tab scanned from.

final class StoreCheckProvider
    extends
        $FunctionalProvider<
          AsyncValue<StoreCheck>,
          StoreCheck,
          Stream<StoreCheck>
        >
    with $FutureModifier<StoreCheck>, $StreamProvider<StoreCheck> {
  /// Store-mode result for a scanned ISBN; [type] is the tab scanned from.
  StoreCheckProvider._({
    required StoreCheckFamily super.from,
    required (String, CollectionType) super.argument,
  }) : super(
         retry: null,
         name: r'storeCheckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storeCheckHash();

  @override
  String toString() {
    return r'storeCheckProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<StoreCheck> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<StoreCheck> create(Ref ref) {
    final argument = this.argument as (String, CollectionType);
    return storeCheck(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreCheckProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storeCheckHash() => r'69cd7dea8a0f8d9c648924135fba5002631c3906';

/// Store-mode result for a scanned ISBN; [type] is the tab scanned from.

final class StoreCheckFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<StoreCheck>,
          (String, CollectionType)
        > {
  StoreCheckFamily._()
    : super(
        retry: null,
        name: r'storeCheckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Store-mode result for a scanned ISBN; [type] is the tab scanned from.

  StoreCheckProvider call(String isbn13, CollectionType type) =>
      StoreCheckProvider._(argument: (isbn13, type), from: this);

  @override
  String toString() => r'storeCheckProvider';
}
