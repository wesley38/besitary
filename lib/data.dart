import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:json_serializable/json_serializable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dish.dart';
import 'dart:io';

part 'data.g.dart';

// Class handling Json store of IDs
@JsonSerializable()
class IDStore {
  IDStore(this.ids);

  final List<String> ids;

  factory IDStore.fromJson(Map<String, dynamic> json) =>
      _$IDStoreFromJson(json);

  Map<String, dynamic> toJson() => _$IDStoreToJson(this);
}

// Handles reading and writing of ids
class IDStorage {
  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File("${directory.path}/ids.json");
    await file.writeAsString(text);
  }

  Future<String?> _read() async {
    String? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File("${directory.path}/ids.json");
      text = await file.readAsString();
    } catch (e) {
      text = null;
      print("Couldn't read file"); // TODO: Logging solution.
    }
    return text;
  }

  // Get list of all current ids
  List<String> getIDs() {
    String? idFile;

    _read().then((value) {
      idFile = value;
    });

    if (idFile == null) {
      IDStore newStore = IDStore([]);
      String newFile = jsonEncode(newStore);
      _write(newFile);
    }

    Map<String, dynamic> idMap = jsonDecode(idFile!);
    return IDStore.fromJson(idMap).ids;
  }

  // Writes new ID to file
  void newID(String id) {
    List<String> idList = getIDs();

    idList.add(id);

    IDStore newStore = IDStore([]);
    String newFile = jsonEncode(newStore);
    _write(newFile);
  }
}
