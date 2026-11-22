// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_proposals.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Proposals waiting in Plus → Qualité (filled by "Compléter les
/// couvertures manquantes").

@ProviderFor(CoverProposals)
final coverProposalsProvider = CoverProposalsProvider._();

/// Proposals waiting in Plus → Qualité (filled by "Compléter les
/// couvertures manquantes").
final class CoverProposalsProvider
    extends $NotifierProvider<CoverProposals, List<CoverProposal>> {
  /// Proposals waiting in Plus → Qualité (filled by "Compléter les
  /// couvertures manquantes").
  CoverProposalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverProposalsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverProposalsHash();

  @$internal
  @override
  CoverProposals create() => CoverProposals();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CoverProposal> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CoverProposal>>(value),
    );
  }
}

String _$coverProposalsHash() => r'26000efccece9fc65666cc162d3b078b40b08e04';

/// Proposals waiting in Plus → Qualité (filled by "Compléter les
/// couvertures manquantes").

abstract class _$CoverProposals extends $Notifier<List<CoverProposal>> {
  List<CoverProposal> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<CoverProposal>, List<CoverProposal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CoverProposal>, List<CoverProposal>>,
              List<CoverProposal>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
