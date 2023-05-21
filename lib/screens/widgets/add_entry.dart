import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_tracker/api_calls.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show QuillController, QuillToolbar, QuillEditor;
import 'package:media_tracker/screens/homepage.dart';

import '../../data.dart';

class AddEntryScreen extends ConsumerStatefulWidget {
  AddEntryScreen({super.key});

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  EntryType? _type = null;
  String? _selectedCategory = '';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _rating = -1;
  String _imageURL = '';
  String _imagePreview = '';

  final _searchController = TextEditingController();
  List<Entry> _searchEntries = [];

  final _reviewController = QuillController.basic();
  int _part = 1;
  List<bool> tagCheckbox = [];

  List<String> _getSelectedTags(List<String> tags) {
    List<String> resTags = [];
    for (int i = 0; i < tags.length; i++) {
      if (tagCheckbox[i] == true) {
        resTags.add(tags[i]);
      }
    }
    return resTags;
  }

  @override
  Widget build(BuildContext context) {
    if (tagCheckbox.isEmpty) {
      tagCheckbox = List<bool>.filled(tags.length, false);
    }
    Future<List<Entry>> fetchSearchEntries() async {
      List<Entry> entries = [];
      var httpResponse;
      if (_type == EntryType.Book) {
        httpResponse = await bookAPIs(
            'https://hapi-books.p.rapidapi.com/search/${_searchController.text}');
        var jsonData = jsonDecode(httpResponse.body);
        for (var element in jsonData) {
          Entry newEntry = Entry(
            title: element['name'],
            description: element['book_id'].toString(),
            imageURL: element['cover'],
            type: _type!,
          );
          entries.add(newEntry);
        }
      } else if (_type == EntryType.Movie) {
        httpResponse = await movieAPIs(
            'https://movies-tv-shows-database.p.rapidapi.com/?title=${_searchController.text}');
        var jsonData = jsonDecode(httpResponse.body);
        jsonData = jsonData['movie_results'];
        for (var element in jsonData) {
          Entry newEntry = Entry(
            title: element['title'],
            description: element['year'].toString(),
            type: _type!,
          );
          entries.add(newEntry);
        }
      } else if (_type == EntryType.Show) {
        httpResponse = await showAPIs(
            'https://movies-tv-shows-database.p.rapidapi.com/?title=${_searchController.text}');
        var jsonData = jsonDecode(httpResponse.body);
        jsonData = jsonData['tv_results'];
        for (var element in jsonData) {
          Entry newEntry = Entry(
            title: element['title'],
            description: element['release_date'].toString(),
            type: _type!,
          );
          entries.add(newEntry);
        }
      } else {
        // TODO FIX GAME API
        httpResponse = await gameAPIs(
            'https://computer-games-info.p.rapidapi.com/search?query=${_searchController.text}');
        print(httpResponse.body);
        for (var elem in httpResponse.body) {
          print(elem['developer'].toString());
        }
        var jsonData = jsonDecode(httpResponse.body);
        for (var element in jsonData) {
          Entry newEntry = Entry(
            title: element['title'],
            description: element['game_description'].toString(),
            type: _type!,
          );
          entries.add(newEntry);
        }
      }

      return entries;
    }

    return _part == 1
        ?
        // Type picker
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: ListView.builder(
              itemCount: EntryType.values.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _type = EntryType.values[index];
                          setState(() {
                            HapticFeedback.heavyImpact();
                            _part++;
                          });
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(entryTypeIconMap[EntryType.values[index]]),
                              Text(EntryType.values[index].name),
                            ],
                          ),
                          Text(entryTypeDescriptionMap[
                              EntryType.values[index]]!),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : _part == 2
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            _part--;
                            _type = null;
                            _searchEntries = [];
                          }),
                          icon: Icon(Icons.arrow_back),
                        ),
                        // Barcode
                        TextButton(
                          onPressed: () async {
                            String barcodeScanRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#ff6666", 'BACK', true, ScanMode.BARCODE);

                            var response = await http.get(Uri.parse(
                                'https://api.upcitemdb.com/prod/trial/lookup?upc=$barcodeScanRes'));

                            var jsonData = jsonDecode(response.body);

                            if (jsonData["total"] == 0) {
                              print("No Product found for the given UPC");
                            } else {
                              print(jsonData);

                              var scannedTitle =
                                  (jsonData["items"][0]["title"]);
                              var scannedDesc =
                                  (jsonData["items"][0]["description"]);
                              var scannedCategory =
                                  (jsonData["items"][0]["category"]);
                              var scannedISBN = (jsonData["items"][0]["isbn"]);
                              var scannedImage = null;

                              if (jsonData["items"][0]["images"].length > 0) {
                                scannedImage =
                                    (jsonData["items"][0]["images"][0]);
                              } else {
                                print('no images');
                              }

                              setState(() {
                                if (scannedTitle != null) {
                                  _titleController.value =
                                      TextEditingValue(text: scannedTitle);
                                  if (scannedDesc != null) {
                                    _descriptionController.value =
                                        TextEditingValue(text: scannedDesc);
                                  }
                                  if (scannedCategory != null) {
                                    if (scannedCategory == 'Media > Books') {
                                      if (scannedISBN != null) {
                                        _descriptionController.value =
                                            TextEditingValue(
                                                text: _descriptionController
                                                        .text +
                                                    scannedISBN);
                                      }
                                    }
                                  }
                                  if (scannedImage != null) {
                                    _imageURL = scannedImage;
                                  }
                                }
                                setState(() {
                                  HapticFeedback.heavyImpact();
                                  _part++;
                                });
                              });
                            }
                          },
                          child: const Text('Barcode'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              HapticFeedback.heavyImpact();
                              _part++;
                            });
                          },
                          child: Text('Add manually'),
                        ),
                      ],
                    ),
                    Text('Find ${_type!.name} Online'),
                    // Search fields
                    Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                // Make an api call and get the proper metadata
                                final _tempentries = await fetchSearchEntries();
                                setState(() {
                                  _searchEntries = _tempentries;
                                });
                              },
                              icon: Icon(Icons.search)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchEntries.length,
                        itemBuilder: (context, index) => ElevatedButton(
                          onPressed: () {
                            ref
                                .read(entryProvider.notifier)
                                .addEntry(_searchEntries[index]);

                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_searchEntries[index].title,
                                            overflow: TextOverflow.ellipsis),
                                        Text(
                                          _searchEntries[index].description,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    if (_searchEntries[index]
                                        .imageURL
                                        .isNotEmpty)
                                      Image.network(
                                          _searchEntries[index].imageURL),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _part == 3
                ?
                // Load the Form
                Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                _part--;
                              }),
                              icon: Icon(Icons.arrow_back),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  HapticFeedback.heavyImpact();
                                  _part++;
                                });
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                        Text('New ${_type!.name}'),
                        // Title
                        TextFormField(
                            autofocus: true,
                            controller: _titleController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            )),
                        // Description
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 1,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            label: Text('Description'),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
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
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          // Capture
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              XFile? xFile =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                              if (xFile !=
                                                                  null) {
                                                                Uint8List
                                                                    bytes =
                                                                    await xFile!
                                                                        .readAsBytes();
                                                                _imageURL =
                                                                    File(xFile
                                                                            .path)
                                                                        .path;
                                                              }
                                                              Navigator.pop(
                                                                  context);
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
                                                            onPressed:
                                                                () async {
                                                              XFile? xFile =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                              if (xFile !=
                                                                  null) {
                                                                Uint8List
                                                                    bytes =
                                                                    await xFile!
                                                                        .readAsBytes();
                                                                _imageURL =
                                                                    File(xFile
                                                                            .path)
                                                                        .path;
                                                              }
                                                              Navigator.pop(
                                                                  context);
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
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt_outlined),
                                      Text('Browse'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Category
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text('Category'),
                                    value: _selectedCategory == ''
                                        ? null
                                        : _selectedCategory,
                                    items: categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCategory = newValue!;
                                      });
                                    },
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Image
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: tags.length,
                            itemBuilder: (context, index) => CheckboxListTile(
                              value: tagCheckbox[index],
                              onChanged: (value) => setState(() {
                                tagCheckbox[index] = value!;
                              }),
                              title: Text(tags[index]),
                            ),
                          ),
                        ),

                        // for (int i = 0; i < tags.length; i++)
                        //   CheckboxListTile(
                        //     title: Text(tags[i]),
                        //     value: tagCheckbox[i],
                        //     onChanged: (value) => setState(
                        //       () {
                        //         tagCheckbox[i] = value!;
                        //         print(tagCheckbox);
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  )
                : _part == 4
                    ?
                    // Review
                    Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => setState(() {
                                    _part--;
                                  }),
                                  icon: Icon(Icons.arrow_back),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (_titleController.text.isNotEmpty) {
                                      setState(() {
                                        Entry entry = Entry(
                                          title: _titleController.text,
                                          description:
                                              _descriptionController.text,
                                          category: _selectedCategory!,
                                          imageURL: _imageURL,
                                          rating: _rating,
                                          metadata: '',
                                          tags: _getSelectedTags(tags),
                                          userReview: _reviewController.document
                                              .toDelta()
                                              .toJson(),
                                          type: _type!,
                                        );
                                        ref
                                            .read(entryProvider.notifier)
                                            .addEntry(entry);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageScreen(),
                                            ));
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            Text('Thoughts'),
                            QuillToolbar.basic(controller: _reviewController),
                            SizedBox(height: 10),
                            Expanded(
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8),
                                  child: QuillEditor.basic(
                                    controller: _reviewController,
                                    readOnly: false, // true for view only mode
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    :
                    // View Summary
                    Container(child: Text('Summary'));
  }
}
