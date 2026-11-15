// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sources turned off by the user (all on by default), persisted in the
/// `app_settings` table.

@ProviderFor(DisabledSources)
final disabledSourcesProvider = DisabledSourcesProvider._();

/// Sources turned off by the user (all on by default), persisted in the
/// `app_settings` table.
final class DisabledSourcesProvider
    extends $AsyncNotifierProvider<DisabledSources, Set<SourceId>> {
  /// Sources turned off by the user (all on by default), persisted in the
  /// `app_settings` table.
  DisabledSourcesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disabledSourcesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disabledSourcesHash();

  @$internal
  @override
  DisabledSources create() => DisabledSources();
}

String _$disabledSourcesHash() => r'287524ab697595ce9fe2681fe8209e193d941ba5';

/// Sources turned off by the user (all on by default), persisted in the
/// `app_settings` table.

abstract class _$DisabledSources extends $AsyncNotifier<Set<SourceId>> {
  FutureOr<Set<SourceId>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<SourceId>>, Set<SourceId>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<SourceId>>, Set<SourceId>>,
              AsyncValue<Set<SourceId>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
