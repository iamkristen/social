import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social/widgets/custom_button.dart';
import 'package:social/widgets/header.dart';
import 'package:social/widgets/progress.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? username;
  final _formKey = GlobalKey<FormState>();
  // final _scaffoldKey = GlobalKey<FormState>();

  showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar:
          header(context, title: "Setup Your Profile", removeBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset('assets/images/social_logo.svg')),
            const Text("Create Your Username"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (val) {
                    if (val!.trim().length < 3 || val.isEmpty) {
                      return "username too short";
                    } else if (val.trim().length > 12) {
                      return "username too large";
                    }
                  },
                  onChanged: (value) => username = value.trim().toLowerCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      )),
                      border: const OutlineInputBorder(),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: "John123"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  showSnackbar("Welcome $username");
                  circularProgress();
                  Timer(const Duration(seconds: 3), () {
                    Navigator.pop(context, username);
                  });
                }
              },
              child: const CustomButton(text: "Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
