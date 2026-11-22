// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_series.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Titles of the series just completed on this device, for "Série
/// complète !" (listened to by the app).

@ProviderFor(completedSeriesNews)
final completedSeriesNewsProvider = CompletedSeriesNewsProvider._();

/// Titles of the series just completed on this device, for "Série
/// complète !" (listened to by the app).

final class CompletedSeriesNewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// Titles of the series just completed on this device, for "Série
  /// complète !" (listened to by the app).
  CompletedSeriesNewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedSeriesNewsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedSeriesNewsHash();

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    return completedSeriesNews(ref);
  }
}

String _$completedSeriesNewsHash() =>
    r'ca042379a8cc5b5ce46bf5df1f4740b4823d6e32';
