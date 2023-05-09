import 'package:media_tracker/models/entry.dart';

class Show extends ViewableEntry {
  Show({
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
