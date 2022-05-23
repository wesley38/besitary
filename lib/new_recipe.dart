import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';
import 'photo_taker.dart';

class NewRecipePage extends StatefulWidget {
  const NewRecipePage({Key? key}) : super(key: key);

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  @override
  Widget build(BuildContext context) {
    // Page has an AppBar and padding around the new recipe form
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("New Recipe"),
          ),
          body: const Padding(
            padding: EdgeInsets.fromLTRB(7.0, 9.0, 7.0, 9.0),
            child: NewRecipeForm(),
          )),
    );
  }
}

class NewRecipeForm extends StatefulWidget {
  const NewRecipeForm({Key? key}) : super(key: key);

  @override
  State<NewRecipeForm> createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  final _formKey = GlobalKey<FormState>();

  // Styling for text used for labels
  final TextStyle _labelStyle = const TextStyle(
    color: kprimaryDark,
    fontSize: 20.0,
  );

  // Generate input decoration
  InputDecoration createInput(String inputName, Icon icon, String? helperText) {
    return InputDecoration(
      labelText: inputName,
      border: const OutlineInputBorder(),
      icon: icon,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kprimaryLight),
      ),
      focusColor: kprimaryDark,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kprimaryDark, width: 2.0),
      ),
      labelStyle: const TextStyle(color: kprimary),
      helperText: helperText,
    );
  }

  // Form to input new recipe
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          NewPhoto(), // Handles photos
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            // Recipe name field
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a recipe name";
              }
              return null;
            },
            decoration: createInput(
                "Recipe Name",
                const Icon(
                  Icons.restaurant,
                  color: ksecondaryDark,
                ),
                null),
            cursorColor: kprimaryDark,
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            // Recipe description field
            decoration: createInput(
                "Description",
                const Icon(
                  Icons.description,
                  color: ksecondaryDark,
                ),
                "Optional"),
            cursorColor: kprimaryDark,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text(
              "SUBMIT",
            ),
          )
        ],
      ),
    );
  }
}
