import 'dart:typed_data';
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

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  var _selectedCategory;
  var _selectedType;
  var _rating;

  final categories = ['', 'readed', 'backlog', 'finished'];
  final tags = ['fadslkj', 'aaa', 'daa', 'cgaa'];
  final types = [
    'Book',
    'Manga',
    'Comic',
    'Movie',
    'Anime',
    'TV Show',
  ];
  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    List<String> _getNotSelectedTags() {
      List<String> notSelectedTags = [];
      for (final tag in tags) {
        if (!selectedTags.contains(tag)) {
          notSelectedTags.add(tag);
        }
      }
      return notSelectedTags;
    }

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final commentController = TextEditingController();

    _selectedCategory ??= categories.first;
    _selectedType ??= types.first;
    var _imageFile = '';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                autofocus: true,
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                )),
            // Description
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                label: Text('Description'),
              ),
            ),
            // Comment
            const SizedBox(height: 10),
            TextField(
              minLines: 2,
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
                        items: types.map((type) {
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
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(0)),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
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
                                                                  source:
                                                                      ImageSource
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
                                                        Icon(Icons.add_a_photo),
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
                                                        Icon(Icons.photo_album),
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
                      var scannedCategory = (jsonData["items"][0]["category"]);
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
                                descriptionController.value = TextEditingValue(
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
                    if (titleController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const SnackBar(
                            content: Text('Title can not be empty!')),
                      );
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/gridview');
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
