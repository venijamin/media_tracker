import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:media_tracker/screens/view_entry.dart';

class GridDisplayTile extends StatelessWidget {
  const GridDisplayTile({
    super.key,
    required this.entry,
  });
  final entry;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide.none,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEntry(entry: entry),
            ),
          ),
          child: Container(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 5  horizontally
                          0.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                    image: entry.image.startsWith('http')
                        ? DecorationImage(
                            image: NetworkImage(entry.image),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                FileImage(File.fromUri(Uri(path: entry.image))),
                          ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                Container(
                  height: 350.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Colors.black12,
                            Colors.black38,
                          ],
                          stops: [
                            0.0,
                            0.8,
                            1.0
                          ])),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    entry.rating == 0.0
                        ? SizedBox()
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent.shade700,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              entry.rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
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
