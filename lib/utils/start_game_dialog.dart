import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake_flutter/text_field_themes.dart';

class StartGameDialog {
  static Future<List<String>> showStartDialog(BuildContext context) async {
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
                  "Enter settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
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
                const SizedBox(height: 20),
                Column(
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
              ],
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
                    Navigator.of(context).pop([nickname, actualMode]);
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
