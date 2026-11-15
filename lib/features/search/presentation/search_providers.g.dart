// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localSearch)
final localSearchProvider = LocalSearchFamily._();

final class LocalSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalSearchResults>,
          LocalSearchResults,
          FutureOr<LocalSearchResults>
        >
    with
        $FutureModifier<LocalSearchResults>,
        $FutureProvider<LocalSearchResults> {
  LocalSearchProvider._({
    required LocalSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'localSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$localSearchHash();

  @override
  String toString() {
    return r'localSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LocalSearchResults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalSearchResults> create(Ref ref) {
    final argument = this.argument as String;
    return localSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$localSearchHash() => r'd169e4303d091ad212486e642d02ec06dcd0e1e1';

final class LocalSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LocalSearchResults>, String> {
  LocalSearchFamily._()
    : super(
        retry: null,
        name: r'localSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LocalSearchProvider call(String query) =>
      LocalSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'localSearchProvider';
}
