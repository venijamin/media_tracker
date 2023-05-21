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

class EditEntryScreen extends ConsumerStatefulWidget {
  EditEntryScreen({super.key, required this.entry});
  Entry entry;

  @override
  ConsumerState<EditEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<EditEntryScreen> {
  String? _selectedCategory = '';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _rating = -1;
  String _imageURL = '';

  String _imagePreview = '';

  final _reviewController = QuillController.basic();
  int _part = 1;
  List<bool> tagCheckbox = [];

  bool _firstTimeEdit = true;
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
    if (_firstTimeEdit) {
      _titleController.value = TextEditingValue(text: widget.entry.title);
      _descriptionController.value =
          TextEditingValue(text: widget.entry.description);
      _rating = widget.entry.rating;
      _imageURL = widget.entry.imageURL;
      _selectedCategory = widget.entry.category;
      _firstTimeEdit = false;
    }
    if (tagCheckbox.isEmpty) {
      tagCheckbox = List<bool>.filled(tags.length, false);
      for (var etag in widget.entry.tags) {
        var tagIndex = tags.indexOf(etag);
        tagCheckbox[tagIndex] = true;
      }
    }
    // Load the Form
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    HapticFeedback.heavyImpact();
                    if (_titleController.text.isNotEmpty) {
                      Entry newEntry = Entry(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        type: widget.entry.type,
                        category: _selectedCategory!,
                        imageURL: _imageURL,
                        metadata: '',
                        rating: _rating,
                        tags: _getSelectedTags(tags),
                        userReview: widget.entry.userReview,
                      );

                      ref
                          .read(entryProvider.notifier)
                          .editEntry(widget.entry, newEntry);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePageScreen(),
                          ));
                    }
                  });
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          Text('Edit ${widget.entry.title}'),
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
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                  Uint8List bytes = await xFile!
                                                      .readAsBytes();
                                                  _imageURL =
                                                      File(xFile.path).path;
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
                                                  Uint8List bytes = await xFile!
                                                      .readAsBytes();
                                                  _imageURL =
                                                      File(xFile.path).path;
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
                      value: _selectedCategory == '' ? null : _selectedCategory,
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
                        initialRating: _rating,
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
          // Tags
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
    );
  }
}
