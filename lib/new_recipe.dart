import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

class NewRecipePage extends StatefulWidget {
  const NewRecipePage({Key? key}) : super(key: key);

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  @override
  Widget build(BuildContext context) {
    // Page has an AppBar and padding around the new recipe form
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Recipe"),
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(7.0, 9.0, 7.0, 9.0),
          child: NewRecipeForm(),
        ));
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
  InputDecoration createInput(String inputName) {
    return InputDecoration(
        labelText: inputName,
        border: const OutlineInputBorder(),
        icon: const Icon(
          Icons.restaurant,
          color: ksecondaryDark,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryLight),
        ),
        focusColor: kprimaryDark,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryDark),
        ),
        labelStyle: const TextStyle(color: kprimaryDark));
  }

  // Form to input new recipe
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a recipe name";
              }
              return null;
            },
            decoration: createInput("Recipe Name"),
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
