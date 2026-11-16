// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_title_fill.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Looks the volumes without own title up again by ISBN (answers are often
/// already in the disk cache) and saves the title the sources give; nothing
/// else changes, and a title typed meanwhile is kept.

@ProviderFor(VolumeTitleFill)
final volumeTitleFillProvider = VolumeTitleFillProvider._();

/// Looks the volumes without own title up again by ISBN (answers are often
/// already in the disk cache) and saves the title the sources give; nothing
/// else changes, and a title typed meanwhile is kept.
final class VolumeTitleFillProvider
    extends $NotifierProvider<VolumeTitleFill, TitleFillState> {
  /// Looks the volumes without own title up again by ISBN (answers are often
  /// already in the disk cache) and saves the title the sources give; nothing
  /// else changes, and a title typed meanwhile is kept.
  VolumeTitleFillProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volumeTitleFillProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volumeTitleFillHash();

  @$internal
  @override
  VolumeTitleFill create() => VolumeTitleFill();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TitleFillState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TitleFillState>(value),
    );
  }
}

String _$volumeTitleFillHash() => r'ed49f94f9399e1a6877f26228daebb5020ce1bac';

/// Looks the volumes without own title up again by ISBN (answers are often
/// already in the disk cache) and saves the title the sources give; nothing
/// else changes, and a title typed meanwhile is kept.

abstract class _$VolumeTitleFill extends $Notifier<TitleFillState> {
  TitleFillState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TitleFillState, TitleFillState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TitleFillState, TitleFillState>,
              TitleFillState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
