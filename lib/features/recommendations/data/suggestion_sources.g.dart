// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(suggestionSources)
final suggestionSourcesProvider = SuggestionSourcesProvider._();

final class SuggestionSourcesProvider
    extends
        $FunctionalProvider<
          SuggestionSources,
          SuggestionSources,
          SuggestionSources
        >
    with $Provider<SuggestionSources> {
  SuggestionSourcesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestionSourcesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestionSourcesHash();

  @$internal
  @override
  $ProviderElement<SuggestionSources> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SuggestionSources create(Ref ref) {
    return suggestionSources(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuggestionSources value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuggestionSources>(value),
    );
  }
}

String _$suggestionSourcesHash() => r'70dc83f8bc454b1aa9c8853e1dbb50bd096b3474';
