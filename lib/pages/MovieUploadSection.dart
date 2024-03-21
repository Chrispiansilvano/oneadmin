import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MovieUploadForm extends StatefulWidget {
  const MovieUploadForm({super.key});

  @override
  _MovieUploadFormState createState() => _MovieUploadFormState();
}

class _MovieUploadFormState extends State<MovieUploadForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  String _thumbnailUrl = "";
  List<String> _tags = [];
  List<String> _cast = []; // List to store movie cast members
  String _director = "";
  String _genre = "";
  String _releasedYear = "";

  // Firebase Storage reference
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Firestore collection reference
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  // List of available tags
  final List<String> _availableTags = [
    "Trending Now",
    "Popular Movies",
    "Series"
  ];

  // List of available genres
  final List<String> _availableGenres = [
    "Drama",
    "Thriller",
    "Sci-Fi",
    "Comedy",
    "Action"
  ];

  Future<String> _uploadMovie(String fileName) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      final uploadedFile = File(result.files.single.path!);
      final storageRef = _storage.ref().child('movies/$fileName');
      await storageRef.putFile(uploadedFile);
      return await storageRef.getDownloadURL();
    }
    return "";
  }

  Future<String> _uploadThumbnail(String fileName) async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    final uploadedFile = File(result!.files.single.path!);
    final storageRef = _storage.ref().child('thumbnails/$fileName');
    await storageRef.putFile(uploadedFile);
    return await storageRef.getDownloadURL();
    return "";
  }

  Future<void> _submitMovie() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final thumbnailUrl = await _uploadThumbnail(_title);
      final movieUrl = await _uploadMovie(_title);
      await _movies.add({
        'title': _title,
        'description': _description,
        'thumbnailUrl': thumbnailUrl,
        'tags': _tags,
        'cast': _cast, // Add cast list to Firestore data
        'director': _director,
        'genre': _genre,
        'releasedYear': _releasedYear,
      });
      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie uploaded successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Movie upload button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: () async {
                        final movieUrl = await _uploadMovie(_title);
                        if (movieUrl.isNotEmpty) {
                          // Show a success message or navigate to another screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Movie file uploaded successfully!')),
                          );
                        } else {
                          // Show an error message if upload fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to upload movie file!')),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(234, 230, 230, 230)
                                    .withOpacity(
                                        0.1), // Semi-transparent gray shadow
                                offset: const Offset(5.0,
                                    5.0), // Offset the shadow 5px to the right and bottom
                                blurRadius: 4.0, // Blur the shadow slightly
                              ),
                            ],
                            color: const Color.fromARGB(179, 4, 35, 97),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 106, 183, 246),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Icon(
                                  Icons.cloud_upload_outlined,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Upload",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Upload from computer",
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w900,
                                          // fontSize: 15,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Title field
                  Row(
                    children: [
                      const Text(
                        'Title:',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter movie title',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a title' : null,
                            onSaved: (value) =>
                                setState(() => _title = value!)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Description field
                  Row(
                    children: [
                      const Text('Description:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter movie description',
                              // maxLines: 5,
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a description'
                                : null,
                            onSaved: (value) =>
                                setState(() => _description = value!)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Thumbnail upload
                  Row(
                    children: [
                      const Text('Thumbnail:'),
                      const SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          final url = await _uploadThumbnail(_title);
                          setState(() => _thumbnailUrl = url);
                        },
                        child: const Text('Upload Thumbnail'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Tags dropdown
                  Row(
                    children: [
                      const Text('Tags:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _tags.isEmpty
                              ? null
                              : _tags[0], // Set initial selected value
                          items: _availableTags
                              .map((tag) => DropdownMenuItem<String>(
                                    value: tag,
                                    child: Text(tag),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _tags = [value!]),
                          validator: (value) =>
                              value == null ? 'Please select a tag' : null,
                          hint: const Text('Select Tag'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Cast (text field with comma separated entries)
                  Row(
                    children: [
                      const Text('Cast:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Enter cast members (comma separated)',
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter cast members'
                              : null,
                          onSaved: (value) => setState(() => _cast = value!
                              .split(',')
                              .map((e) => e.trim())
                              .toList()), // Split and trim cast names
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Director text field
                  Row(
                    children: [
                      const Text('Director:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Enter director name',
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter director name'
                              : null,
                          onSaved: (value) =>
                              setState(() => _director = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Genre dropdown
                  Row(
                    children: [
                      const Text('Genre:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _genre.isEmpty ? null : _genre,
                          items: _availableGenres
                              .map((genre) => DropdownMenuItem<String>(
                                    value: genre,
                                    child: Text(genre),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _genre = value!),
                          validator: (value) =>
                              value == null ? 'Please select a genre' : null,
                          hint: const Text('Select Genre'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Released year text field
                  Row(
                    children: [
                      const Text('Released Year:'),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Enter year (YYYY)',
                          ),
                          keyboardType: TextInputType
                              .number, // Set keyboard type for numbers
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter released year';
                            } else if (int.tryParse(value) == null) {
                              return 'Invalid year format';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) =>
                              setState(() => _releasedYear = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Submit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _submitMovie,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 50,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                          234, 230, 230, 230)
                                      .withOpacity(
                                          0.1), // Semi-transparent gray shadow
                                  offset: const Offset(5.0,
                                      5.0), // Offset the shadow 5px to the right and bottom
                                  blurRadius: 4.0, // Blur the shadow slightly
                                ),
                              ],
                              color: const Color.fromARGB(179, 4, 35, 97),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: const Center(
                              child: Text(
                            'Upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
