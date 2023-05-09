import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/data/dummy_data.dart';
import 'package:media_tracker/models/book.dart';

final bookProvider = Provider<List<Book>>((ref) {
  return DummyData().bookRepository.getEntries();
});
