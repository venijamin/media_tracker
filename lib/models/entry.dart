import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:media_tracker/models/type.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

final uuid = Uuid();

class Entry {
  Entry({
    required this.title,
    this.description = '',
    this.userReview = const [],
    required this.type,
    this.imageURL = '',
    this.category = '',
    this.rating = -1,
    this.tags = const [],
    this.metadata = '',
  }) : id = uuid.v4();

  String id;
  String title;
  String description;

  double rating;

  List<dynamic> userReview;

  EntryType type;

  String imageURL;

  // read, backlog, reading, etc..
  String category;

  List<String> tags;

  String metadata;

  static Entry fromJson(Map<String, dynamic> json) {
    EntryType type;
    if (json['type'] == 'Show') {
      type = EntryType.Show;
    } else if (json['type'] == 'Game') {
      type = EntryType.Game;
    } else if (json['type'] == 'Movie') {
      type = EntryType.Movie;
    } else {
      type = EntryType.Book;
    }
    Entry entry = Entry(
      title: json['title'],
      type: type,
      category: json['category'],
      description: json['description'],
      imageURL: json['imageURL'],
      metadata: json['metadata'],
      rating: json['rating'],
      tags: json['tags'],
      userReview: json['userReview'],
    );
    entry.id = json['id'];

    return entry;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'rating': rating,
        'userReview': userReview,
        'type': type.name,
        'imageURL': imageURL,
        'category': category,
        'tags': tags,
        'metadata': metadata,
      };
}
