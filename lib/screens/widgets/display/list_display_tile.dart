import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:motion/motion.dart';

import '../view_entry.dart';

class ListDisplayTile extends ConsumerWidget {
  final Entry entry;
  const ListDisplayTile({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Motion.only(
        child: ElevatedButton(
          onLongPress: () =>
              ref.read(entryProvider.notifier).removeEntry(entry),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => ViewEntryScreen(entry: entry),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                entry.imageURL.isEmpty
                    ? SizedBox(width: 80)
                    : entry.imageURL.startsWith('http')
                        ? Container(
                            width: 80,
                            child: Image(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(entry.imageURL)))
                        : Container(
                            width: 80,
                            child: Image(
                                fit: BoxFit.contain,
                                image: FileImage(
                                    File.fromUri(Uri(path: entry.imageURL))))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            entry.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(entry.category),
                          entry.rating == -1
                              ? SizedBox()
                              : Text(entry.rating.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
