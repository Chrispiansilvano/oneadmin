import 'package:flutter/material.dart';
import 'package:oneadmin/pages/MovieUploadSection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const Upload()));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  MovieUploadForm()));
                  // Add your button functionality here
                },
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.1), // Semi-transparent gray shadow
                          offset: const Offset(5.0,
                              5.0), // Offset the shadow 5px to the right and bottom
                          blurRadius: 4.0, // Blur the shadow slightly
                        ),
                      ],
                      color: const Color.fromARGB(252, 255, 253, 253),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                                    fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                              Text("Upload from computer")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
