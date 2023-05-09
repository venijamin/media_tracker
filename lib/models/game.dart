import 'package:media_tracker/models/entry.dart';

class Game extends PlayableEntry {
  Game({
    required super.title,
    super.description = '',
    super.comment = '',
    super.rating = 0,
    super.image = '',
    super.category = '',
    super.tags = const [],
    super.publisher = '',
    super.hoursPlayed = -1,
    super.developer = '',
  });
}
