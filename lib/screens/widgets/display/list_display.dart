import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:media_tracker/providers/type_provider.dart';
import 'package:media_tracker/screens/widgets/display/list_display_tile.dart';

class ListDisplayScreen extends ConsumerWidget {
  const ListDisplayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EntryType _selectedType = ref.watch(typeProvider.notifier).getType();
    final entries =
        ref.watch(entryProvider.notifier).getEntriesByType(_selectedType);
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return ListDisplayTile(
          entry: entries[index],
        );
      },
    );
  }
}
