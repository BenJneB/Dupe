import 'package:dupe/core/utils/db_enum.dart';

enum PublicationStatus implements DbEnum {
  enCours('en_cours'),
  terminee('terminee'),
  inconnue('inconnue');

  new(this.dbValue);

  @override
  final String dbValue;
}

enum Ownership implements DbEnum {
  possede('possede'),
  envie('envie');

  new(this.dbValue);

  @override
  final String dbValue;
}

enum ReadingStatus implements DbEnum {
  nonLu('non_lu'),
  enCours('en_cours'),
  lu('lu'),
  abandonne('abandonne');

  new(this.dbValue);

  @override
  final String dbValue;
}
