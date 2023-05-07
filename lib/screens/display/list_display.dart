import 'package:flutter/material.dart';
import 'package:media_tracker/screens/display/widgets/list_display_tile.dart';

class ListDisplayScreen extends StatelessWidget {
  const ListDisplayScreen({super.key, required this.entries});
  final entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        var entry = entries[index];
        return ListDisplayTile(
          entry: entry,
        );
      },
    );
  }
}
