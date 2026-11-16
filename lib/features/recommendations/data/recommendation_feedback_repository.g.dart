// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_feedback_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recommendationFeedbackRepository)
final recommendationFeedbackRepositoryProvider =
    RecommendationFeedbackRepositoryProvider._();

final class RecommendationFeedbackRepositoryProvider
    extends
        $FunctionalProvider<
          RecommendationFeedbackRepository,
          RecommendationFeedbackRepository,
          RecommendationFeedbackRepository
        >
    with $Provider<RecommendationFeedbackRepository> {
  RecommendationFeedbackRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendationFeedbackRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendationFeedbackRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecommendationFeedbackRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecommendationFeedbackRepository create(Ref ref) {
    return recommendationFeedbackRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecommendationFeedbackRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecommendationFeedbackRepository>(
        value,
      ),
    );
  }
}

String _$recommendationFeedbackRepositoryHash() =>
    r'8500ceb4213ad3bae2a8d1ed7cb3fa7780858457';
