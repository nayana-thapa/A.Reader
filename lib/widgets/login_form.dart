import 'package:a_reader/screens/main_screen.dart';
import 'package:a_reader/widgets/input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
  })  : _formKey = formKey,
        _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    GlobalKey _scaffold = GlobalKey();
    return new WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'Back Button Disabled',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        return false;
      },
      child: 
     Form(
      key: _formKey,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? 'Please add an email' : null;
            },
            controller: _emailTextController,
            decoration: buildInputDecoration(
                label: 'Enter email', hintText: 'nayana@gmail.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
              validator: (value) {
                return value.isEmpty ? 'Enter password' : null;
              },
              controller: _passwordTextController,
              obscureText: true,
              decoration:
                  buildInputDecoration(label: 'password', hintText: '')),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
            child: Text('Sign In'),
            style: TextButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                backgroundColor: Colors.amber,
                textStyle: TextStyle(fontSize: 18)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreenPage()));
                }).catchError((onError) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Oops!'),
                        content: Text('${onError.message}'),
                      );
                    },
                  );
                });
              }
            })
      ]),
    ),
    );
  }
}
