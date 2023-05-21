import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:faded_widget/faded_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show Delta, Document, QuillController, QuillEditor, QuillToolbar;
import 'package:media_tracker/screens/widgets/edit_entry.dart';
import 'package:media_tracker/screens/widgets/edit_entry_review.dart';
import 'package:parallax_sensors_bg/parallax_sensors_bg.dart';

class ViewEntryScreen extends StatelessWidget {
  final Entry entry;

  ViewEntryScreen({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    QuillController _reviewController = QuillController.basic();
    if (!entry.userReview.isEmpty) {
      print(entry.userReview);
      _reviewController = QuillController(
          document: Document.fromJson(entry.userReview),
          selection: const TextSelection.collapsed(offset: 0));
    }

    return Parallax(
      sensor: ParallaxSensor.accelerometer,
      layers: [
        Layer(
          sensitivity: 1,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      entry.imageURL == ''
                          ? SizedBox()
                          : ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(
                                      0, 0, 0, 0.0), // transparent color
                                ),
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: entry.imageURL.contains('http')
                                      ? Image(
                                          image: NetworkImage(entry.imageURL))
                                      : Image(
                                          image: FileImage(
                                            File.fromUri(
                                              Uri(path: entry.imageURL),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              child: Container(
                                width: 150,
                                height: 200,
                                child: entry.imageURL.contains('http')
                                    ? Image(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(entry.imageURL),
                                      )
                                    : Image(
                                        image: FileImage(
                                          File.fromUri(
                                            Uri(path: entry.imageURL),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rating'),
                              RatingBar(
                                initialRating: entry.rating,
                                allowHalfRating: true,
                                onRatingUpdate: (double value) {},
                                itemSize: 24,
                                ratingWidget: RatingWidget(
                                  empty: Icon(Icons.star_outline_rounded),
                                  half: Icon(Icons.star_half_rounded),
                                  full: Icon(Icons.star_rounded),
                                ),
                                ignoreGestures: true,
                              ),
                              Text(entry.category),
                              Container(
                                width: 200,
                                child: AutoSizeText(
                                  entry.title,
                                  minFontSize: 12,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => EditEntryScreen(entry: entry),
                        ),
                        icon: Icon(Icons.edit),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text('Description'),
                      Card(
                        child: ExpandableNotifier(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(20),
                            child: Column(children: [
                              Expandable(
                                  collapsed: ExpandableButton(
                                    child: Text(
                                      entry.description,
                                      maxLines: 3,
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      ExpandableButton(
                                          child: Column(
                                        children: [Text(entry.description)],
                                      ))
                                    ],
                                  ))
                            ]),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Comment'),
                          IconButton(
                            onPressed: () => showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) =>
                                  EditEntryReview(entry: entry),
                            ),
                            icon: Icon(Icons.edit),
                          )
                        ],
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QuillEditor.basic(
                            controller: _reviewController,
                            readOnly: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tags
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: entry.tags.map((String tag) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text(tag)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
