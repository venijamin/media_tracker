import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/models/type.dart';

class TypeProvider extends StateNotifier<EntryType> {
  TypeProvider() : super(EntryType.Book);

  void changeType(EntryType type) {
    state = type;
  }

  EntryType getType() {
    return state;
  }
}

final typeProvider = StateNotifierProvider<TypeProvider, EntryType>(
  (ref) {
    return TypeProvider();
  },
);
