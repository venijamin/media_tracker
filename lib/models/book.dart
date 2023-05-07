import 'package:media_tracker/models/entry.dart';

class Book extends ReadableEntry {
  Book({
    required super.title,
    super.description = '',
    super.comment = '',
    super.rating = 0,
    super.image = '',
    super.category = '',
    super.tags = const [],
    super.author = '',
    super.publisher = '',
    super.numberOfPages = -1,
    this.isbn = '',
  });

  String isbn;
}
