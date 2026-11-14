import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:material_ui/material_ui.dart';

/// State of the series form and its mapping to/from [Series].
class SeriesFormControllers {
  final title = TextEditingController();
  final originalTitle = TextEditingController();
  final authors = TextEditingController();
  final publisher = TextEditingController();
  final collection = TextEditingController();
  final total = TextEditingController();
  final ownedUpTo = TextEditingController();
  final coverUrl = TextEditingController();
  final description = TextEditingController();
  final notes = TextEditingController();
  PublicationStatus status = PublicationStatus.inconnue;
  bool followed = true;
  Map<String, String> externalIds = const {};

  List<TextEditingController> get _all => [
    title,
    originalTitle,
    authors,
    publisher,
    collection,
    total,
    ownedUpTo,
    coverUrl,
    description,
    notes,
  ];

  void fill(Series s) {
    title.text = s.title;
    originalTitle.text = s.originalTitle ?? '';
    authors.text = s.authors.join(', ');
    publisher.text = s.publisher ?? '';
    collection.text = s.collection ?? '';
    total.text = s.totalVolumes?.toString() ?? '';
    coverUrl.text = s.coverUrl ?? '';
    description.text = s.description ?? '';
    notes.text = s.notes ?? '';
    status = s.statusPublication;
    followed = s.followed;
    externalIds = s.externalIds;
  }

  /// Completes the form from an online series; fields already typed by the
  /// user are kept (only empty ones are filled).
  void complete(SeriesMetadata m) {
    void setIfEmpty(TextEditingController c, String? value) {
      if (c.text.trim().isEmpty && value != null) c.text = value;
    }

    setIfEmpty(title, m.title);
    setIfEmpty(originalTitle, m.originalTitle);
    setIfEmpty(authors, m.authors.isEmpty ? null : m.authors.join(', '));
    setIfEmpty(publisher, m.publisher);
    setIfEmpty(total, m.totalVolumes?.toString());
    setIfEmpty(coverUrl, m.coverUrl);
    setIfEmpty(description, m.description);
    if (status == PublicationStatus.inconnue) status = m.status;
    externalIds = {...externalIds, '${m.source.name}_id': m.sourceId};
  }

  Series applyTo(Series s) => s.copyWith(
    title: title.text.trim(),
    originalTitle: textOrNull(originalTitle),
    authors: Formatters.splitList(authors.text),
    publisher: textOrNull(publisher),
    collection: textOrNull(collection),
    statusPublication: status,
    totalVolumes: int.tryParse(total.text),
    followed: followed,
    coverUrl: textOrNull(coverUrl),
    description: textOrNull(description),
    notes: textOrNull(notes),
    externalIds: externalIds,
  );

  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
  }
}
