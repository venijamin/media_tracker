import 'package:media_tracker/models/entry.dart';

class Movie extends ViewableEntry {
  Movie({
    required super.title,
    super.description = '',
    super.comment = '',
    super.rating = 0,
    super.image = '',
    super.category = '',
    super.tags = const [],
    super.director = '',
  });
}
