import 'package:flutter/cupertino.dart';
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

  // Closes an overlay after widgets rebuilt.
  void closeOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  // Function handles selectaion of image through image_picker package
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      // Storing selected / taken image
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      // Closes photo options menu after widget tree rebuilt.
      closeOverlay();
    } on PlatformException catch (e) {
      // TODO: Create UI to let user know of exception.
      print("Failed to pick image $e");
    }
  }

  // Container holding photo options menu for Android
  Container photoOptionsMenu() {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: ksecondary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Navigator.pop(context);
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

  // Action sheet showing photo taking options for ios
  CupertinoActionSheet photoOptionsMenuIOS() {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.camera);
            },
            child: const Text("Take photo")),
        CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.gallery);
            },
            child: const Text("Choose Photo"))
      ],
    );
  }

  // Overlay that shows the photo options menu
  void showPhotoOptions() {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return photoOptionsMenuIOS();
          });
    } else if (Platform.isAndroid) {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return photoOptionsMenu();
          });
    }
  }

  // Confirm photo deletion alert dialog for Android
  AlertDialog confirmDelete() {
    return AlertDialog(
      title: const Text(
        "Delete the photo?",
        style: TextStyle(color: Colors.red),
      ),
      content: const Text("It will be lost forever!"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              setState(() {
                image = null;
              });
              // Closes confirmation menu after widgets rebuilt.
              closeOverlay();
            },
            child: const Text("Confirm"))
      ],
    );
  }

  // Confirm photo deletion alert dialog for IOS
  CupertinoAlertDialog confirmDeleteIOS() {
    return CupertinoAlertDialog(
      title: const Text("Delete the photo?"),
      content: const Text("It will be lost forever!"),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
        CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              setState(() {
                image = null;
              });
              // Closes confirmation menu after widgets rebuilt
              closeOverlay();
            },
            child: const Text("Yes"))
      ],
    );
  }

  // Asks user to confirm whether to delete photo. Implementation is
  // platform specific.
  void showCancelConfirm() {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return confirmDeleteIOS();
          });
    } else if (Platform.isAndroid) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return confirmDelete();
          });
    }
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

  // Displays image in a card widget along with photo options.
  Card imageDisplay() {
    return Card(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.file(image!),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.photo_camera,
                  color: kprimary,
                ),
                onPressed: () {
                  showPhotoOptions();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: kprimary,
                ),
                onPressed: () {
                  showCancelConfirm();
                },
              )
            ],
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return image == null ? addPhotoButton() : imageDisplay();
  }
}
