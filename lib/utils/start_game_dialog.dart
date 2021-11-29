import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_flutter/config/text_field_themes.dart';

class StartGameDialog {
  static Future<List<dynamic>> showStartDialog(BuildContext context) async {
    Uint8List? image;

    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        String nickname = '';
        final _formKey = GlobalKey<FormState>();
        String actualMode = 'normal';

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.amber[700],
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Choose mode",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        RadioListTile(
                          title: const Text(
                            "Normal",
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: Colors.white,
                          value: "normal",
                          groupValue: actualMode,
                          onChanged: (value) {
                            setState(() {
                              actualMode = value as String;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text(
                            "Hard",
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: Colors.white,
                          value: "hard",
                          groupValue: actualMode,
                          onChanged: (value) {
                            setState(() {
                              actualMode = value as String;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Choose avatar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();

                            XFile? newImage = await _picker.pickImage(source: ImageSource.gallery);
                            final tmpImage = await newImage!.readAsBytes();

                            setState(() {
                              image = tmpImage;
                            });
                          },
                          child: image == null
                              ? Container(
                                  height: 60,
                                  width: 60,
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/avatar.png"),
                                    radius: 30,
                                  ),
                                )
                              : Container(
                                  height: 60,
                                  width: 60,
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: MemoryImage(image!),
                                    radius: 30,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter nickname",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter nickname";
                              }
                            },
                            onChanged: (value) {
                              nickname = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: TextFieldThemes.textFieldDecoration("Nickname", ctx),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (image == null) {
                      await rootBundle.load("assets/images/avatar.png").then((data) => image = data.buffer.asUint8List());
                    }

                    Navigator.of(context).pop(
                      [
                        nickname,
                        actualMode,
                        image!,
                      ],
                    );
                  }
                },
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
      },
    );
    if (result == null) {
      return [];
    } else {
      return result;
    }
  }
}
