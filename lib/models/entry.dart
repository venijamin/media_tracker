import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Entry {
  Entry({
    required this.title,
    required this.description,
    required this.comment,
    required this.rating,
    required this.image,
    required this.category,
    required this.tags,
  }) : id = uuid.v4();

  String id;
  String title;
  String description;
  String comment;
  double rating;
  String image;
  String category;
  List<String> tags;
}

class ReadableEntry extends Entry {
  ReadableEntry({
    required super.title,
    required super.description,
    required super.comment,
    required super.rating,
    required super.image,
    required super.category,
    required super.tags,
    required this.author,
    required this.publisher,
    required this.numberOfPages,
  });
  String author;
  String publisher;
  int numberOfPages;
}

class PlayableEntry extends Entry {
  PlayableEntry({
    required super.title,
    required super.description,
    required super.comment,
    required super.rating,
    required super.image,
    required super.category,
    required super.tags,
    required this.developer,
    required this.publisher,
    required this.hoursPlayed,
  });
  String developer;
  String publisher;
  double hoursPlayed;
}

class ViewableEntry extends Entry {
  ViewableEntry({
    required super.title,
    required super.description,
    required super.comment,
    required super.rating,
    required super.image,
    required super.category,
    required super.tags,
    required this.director,
  });

  String director;
}
