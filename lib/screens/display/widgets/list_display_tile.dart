import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/screens/view_entry.dart';
import 'package:motion/motion.dart';

class ListDisplayTile extends StatelessWidget {
  final Entry entry;
  const ListDisplayTile({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Expandable(
      collapsed: Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width - 40,
          color: Colors.transparent,
          height: 100,
          child: Motion.elevated(
            elevation: 5,
            child: ElevatedButton(
              onLongPress: () async {
                HapticFeedback.heavyImpact();
              },
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewEntry(
                    entry: entry,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  entry.image.isEmpty
                      ? SizedBox()
                      : Container(
                          width: 100,
                          child: entry.image.contains('http')
                              ? Image(image: NetworkImage(entry.image))
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      File.fromUri(Uri(path: entry.image))),
                                ),
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          entry.title,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          presetFontSizes: [20, 24],
                        ),
                        Text(entry.rating.toString()),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ExpandableButton(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      expanded: Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width - 40,
          height: 200,
          child: Motion.elevated(
            elevation: 5,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewEntry(
                    entry: entry,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  entry.image.isEmpty
                      ? SizedBox()
                      : Container(
                          width: 150,
                          child: entry.image.contains('http')
                              ? Image(image: NetworkImage(entry.image))
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      File.fromUri(Uri(path: entry.image))),
                                ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                entry.title,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                presetFontSizes: [20, 24],
                              ),
                              Text(entry.rating.toString()),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.25, // set a fraction of parent container width
                            child: AutoSizeText(
                              entry.description,
                              maxLines: 6,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              presetFontSizes: [12],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ExpandableButton(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
