import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'colors.dart';

class NewPhoto extends StatefulWidget {
  const NewPhoto({Key? key}) : super(key: key);

  @override
  State<NewPhoto> createState() => _NewPhotoState();
}

class _NewPhotoState extends State<NewPhoto> {
  OverlayEntry? entry;

  // Stores taken image
  File? image;

  // Function handles selectaion of image through image_picker package
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      // TODO: Create UI to let user know of exception.
      print("Failed to pick image $e");
    }
  }

  // Handles a tap outside overlay menu to make the menu disappear.
  GestureDetector tapOutside() {
    return GestureDetector(
      onTap: () {
        hidePhotoOptions();
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.2),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  // Container holding photo options menu
  Container photOptionsMenu() {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        color: ksecondary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  // Calls pickImage function to select photo through camera
                  pickImage(ImageSource.camera);
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0),
                ),
                child: const Text("Take Photo"),
              ),
              TextButton(
                  onPressed: () {
                    // Calls pickImage function to select photo through gallery
                    pickImage(ImageSource.gallery);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  child: const Text("Choose photo")),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      hidePhotoOptions();
                    },
                    style: TextButton.styleFrom(primary: kprimaryLight),
                    child: const Text("Cancel"),
                  )
                ],
              )
            ],
          ),
        ));
  }

  // Overlay that shows the photo options menu
  void showPhotoOptions() {
    entry = OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0,
            child: Column(children: [
              tapOutside(),
              photOptionsMenu(),
            ])));

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  // Function that hides photo options menu
  void hidePhotoOptions() {
    entry?.remove();
    entry = null;
  }

  // Handles the "Add Photo" icon button.
  Column addPhotoButton() {
    return Column(
      // Add photo button
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: ksecondary,
          child: IconButton(
            onPressed: () {
              showPhotoOptions();
            },
            icon: const Icon(
              Icons.photo_camera,
              color: kprimary,
              size: 30.0,
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          "Add photo",
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return image == null
        ? addPhotoButton()
        : Image.file(image!, width: 150, height: 150, fit: BoxFit.cover);
  }
}
