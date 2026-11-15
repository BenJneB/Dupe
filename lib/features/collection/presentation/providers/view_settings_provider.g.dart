// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollectionViewSettings)
final collectionViewSettingsProvider = CollectionViewSettingsFamily._();

final class CollectionViewSettingsProvider
    extends $NotifierProvider<CollectionViewSettings, ViewSettings> {
  CollectionViewSettingsProvider._({
    required CollectionViewSettingsFamily super.from,
    required CollectionType super.argument,
  }) : super(
         retry: null,
         name: r'collectionViewSettingsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionViewSettingsHash();

  @override
  String toString() {
    return r'collectionViewSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CollectionViewSettings create() => CollectionViewSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ViewSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ViewSettings>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionViewSettingsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionViewSettingsHash() =>
    r'50cb4a75217bb57baf09c9d48b2ef9749149c849';

final class CollectionViewSettingsFamily extends $Family
    with
        $ClassFamilyOverride<
          CollectionViewSettings,
          ViewSettings,
          ViewSettings,
          ViewSettings,
          CollectionType
        > {
  CollectionViewSettingsFamily._()
    : super(
        retry: null,
        name: r'collectionViewSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CollectionViewSettingsProvider call(CollectionType type) =>
      CollectionViewSettingsProvider._(argument: type, from: this);

  @override
  String toString() => r'collectionViewSettingsProvider';
}

abstract class _$CollectionViewSettings extends $Notifier<ViewSettings> {
  late final _$args = ref.$arg as CollectionType;
  CollectionType get type => _$args;

  ViewSettings build(CollectionType type);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ViewSettings, ViewSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ViewSettings, ViewSettings>,
              ViewSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
