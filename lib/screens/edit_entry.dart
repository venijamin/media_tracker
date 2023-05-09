import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:media_tracker/data/dummy_data.dart';
import 'package:media_tracker/models/book.dart';
import 'package:media_tracker/models/game.dart';
import 'package:media_tracker/models/movie.dart';
import 'package:media_tracker/models/tvshow.dart';
import 'package:media_tracker/screens/display/grid_display.dart';

class EditEntryScreen extends StatefulWidget {
  const EditEntryScreen(
      {super.key, required this.entry, required this.onEditEntry});

  final Function onEditEntry;
  final entry;

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  var _selectedCategory;
  var _selectedType;
  var _rating;

  final categories = ['', 'readed', 'backlog', 'finished'];
  final tags = ['fadslkj', 'aaa', 'daa', 'cgaa'];
  final types = {
    'Book': Book,
    'Movie': Movie,
    'Show': Show,
    'Game': Game,
  };
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final commentController = TextEditingController();

  var _imageFile = '';

  var _hoursPlayed = -1;
  var _numberOfPages = -1;
  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    List<String> _getNotSelectedTags() {
      List<String> notSelectedTags = [];

      _selectedCategory ??= categories.first;
      _selectedType ??= types.keys.first;
      for (final tag in tags) {
        if (!selectedTags.contains(tag)) {
          notSelectedTags.add(tag);
        }
      }
      return notSelectedTags;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                  autofocus: true,
                  controller: titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  )),
              // Description
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
              ),
              // Comment
              const SizedBox(height: 10),
              TextFormField(
                minLines: 1,
                maxLines: 5,
                controller: commentController,
                decoration: const InputDecoration(
                  label: Text('Comment'),
                ),
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Category'),
                          TextButton(onPressed: () {}, child: Text('Add new')),
                        ],
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          items: categories.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type'),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          items: types.keys.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Image'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(0)),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.black54; //<-- SEE HERE
                                    }
                                    return Colors
                                        .black; // Defer to the widget's default.
                                  },
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: (() {
                              showDialog(
                                  context: context,
                                  builder: (context) => Container(
                                        child: Dialog(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              height: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // Capture
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        XFile? xFile =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                        if (xFile != null) {
                                                          Uint8List bytes =
                                                              await xFile!
                                                                  .readAsBytes();
                                                          _imageFile =
                                                              File(xFile.path)
                                                                  .path;
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: Column(
                                                        children: const [
                                                          Icon(Icons
                                                              .add_a_photo),
                                                          Text('Capture'),
                                                        ],
                                                      ),
                                                    ),
                                                    // Gallery
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        XFile? xFile =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        if (xFile != null) {
                                                          Uint8List bytes =
                                                              await xFile!
                                                                  .readAsBytes();
                                                          _imageFile =
                                                              File(xFile.path)
                                                                  .path;
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(Icons
                                                              .photo_album),
                                                          Text('Gallery'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                            }),
                            child: Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 48,
                                  ),
                                  Text(
                                    "Browse",
                                    style: TextStyle(height: 2, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "rating",
                        style: TextStyle(fontSize: 16),
                      ),
                      RatingBar(
                        direction: Axis.horizontal,
                        initialRating: 0.0,
                        allowHalfRating: true,
                        minRating: 0,
                        maxRating: 5,
                        glow: false,
                        onRatingUpdate: (double value) {
                          _rating = value;
                        },
                        itemSize: 24,
                        ratingWidget: RatingWidget(
                          empty: Icon(Icons.star_outline_rounded),
                          half: Icon(Icons.star_half_rounded),
                          full: Icon(Icons.star_rounded),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //Tags
              // Selected tags
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Tags'),
                      TextButton(
                        onPressed: () {},
                        child: Text('Add new'),
                      )
                    ],
                  ),
                  Text('Selected'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selectedTags.map((String tag) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedTags.remove(tag);
                                });
                              },
                              child: Text(tag)),
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(),
                  // All tags
                  Text('All'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getNotSelectedTags().map((String tag) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          child: ElevatedButton(
                              onLongPress: () => showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                        child: SingleChildScrollView(
                                      child: Container(
                                        width: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {},
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    Text('Delete')
                                                  ],
                                                )),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Column(
                                                children: [
                                                  Icon(Icons.edit),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ),
                              onPressed: () {
                                setState(() {
                                  if (!selectedTags.contains(tag)) {
                                    selectedTags.add(tag);
                                  }
                                });
                              },
                              child: Text(tag)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String barcodeScanRes =
                          await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666", 'BACK', true, ScanMode.BARCODE);

                      print(barcodeScanRes);

                      var response = await http.get(Uri.parse(
                          'https://api.upcitemdb.com/prod/trial/lookup?upc=$barcodeScanRes'));

                      print(response.body);
                      var jsonData = jsonDecode(response.body);

                      if (jsonData["total"] == 0) {
                        print("No Product found for the given UPC");
                      } else {
                        print(jsonData);

                        var scannedTitle = (jsonData["items"][0]["title"]);
                        var scannedDesc = (jsonData["items"][0]["description"]);
                        var scannedCategory =
                            (jsonData["items"][0]["category"]);
                        var scannedISBN = (jsonData["items"][0]["isbn"]);
                        var scannedImage = null;

                        if (jsonData["items"][0]["images"].length > 0) {
                          scannedImage = (jsonData["items"][0]["images"][0]);
                        } else {
                          print('no images');
                        }

                        setState(() {
                          if (scannedTitle != null) {
                            titleController.value =
                                TextEditingValue(text: scannedTitle);
                            if (scannedDesc != null) {
                              descriptionController.value =
                                  TextEditingValue(text: scannedDesc);
                            }
                            if (scannedCategory != null) {
                              if (scannedCategory == 'Media > Books') {
                                if (scannedISBN != null) {
                                  descriptionController.value =
                                      TextEditingValue(
                                          text: descriptionController.text +
                                              scannedISBN);
                                }
                              }
                            }
                            if (scannedImage != null) {
                              _imageFile = scannedImage;
                            }
                            // TODO Vibrate device
                            HapticFeedback.heavyImpact();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => SnackBar(
                                content: Text('Not found.'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Text('Barcode'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var newEntry;
                      print(newEntry.title);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
