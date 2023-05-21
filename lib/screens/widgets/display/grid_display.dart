import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:media_tracker/providers/type_provider.dart';
import 'package:media_tracker/screens/widgets/display/grid_display_tile.dart';

class GridDisplayScreen extends ConsumerWidget {
  const GridDisplayScreen({super.key, required this.entries});
  final List<Entry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisExtent: 250,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return GridDisplayTile(
          entry: entries[index],
        );
      },
    );
  }
}
