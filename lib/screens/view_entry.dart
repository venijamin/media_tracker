import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motion/motion.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewEntry extends StatelessWidget {
  const ViewEntry({super.key, required this.entry});
  final entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(entry.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    entry.image == ''
                        ? SizedBox()
                        : ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(
                                    0, 0, 0, 0.0), // transparent color
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: entry.image.contains('http')
                                    ? Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(entry.image),
                                      )
                                    : Image(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          File.fromUri(
                                            Uri(path: entry.image),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            child: Container(
                              width: 150,
                              height: 200,
                              child: entry.image.contains('http')
                                  ? Image(
                                      fit: BoxFit.scaleDown,
                                      image: NetworkImage(entry.image),
                                    )
                                  : Image(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File.fromUri(
                                          Uri(path: entry.image),
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
                    Text('Comment'),
                    Card(
                      child: ExpandableNotifier(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(20),
                          child: Column(children: [
                            Expandable(
                                collapsed: ExpandableButton(
                                  child: Text(
                                    entry.comment,
                                    maxLines: 3,
                                  ),
                                ),
                                expanded: Column(
                                  children: [
                                    ExpandableButton(
                                        child: Column(
                                      children: [Text(entry.comment)],
                                    ))
                                  ],
                                ))
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tags
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          width: 100,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.edit_rounded)
              ],
            ),
          ),
        ));
  }
}
