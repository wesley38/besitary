import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'colors.dart';

class NewPhoto extends StatefulWidget {
  const NewPhoto({Key? key}) : super(key: key);

  @override
  State<NewPhoto> createState() => _NewPhotoState();
}

class _NewPhotoState extends State<NewPhoto> {
  OverlayEntry? entry;

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
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0),
                ),
                child: const Text("Take Photo"),
              ),
              TextButton(
                  onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
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
}
