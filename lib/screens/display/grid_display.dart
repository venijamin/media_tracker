import 'package:flutter/material.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/screens/display/widgets/grid_display_tile.dart';

class GridDisplayScreen extends StatelessWidget {
  const GridDisplayScreen({super.key, required this.entries});
  final entries;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisExtent: 250,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        var entry = entries[index];
        return GridDisplayTile(
          entry: entry,
        );
      },
    );
  }
}
