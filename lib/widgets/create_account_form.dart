import 'package:a_reader/screens/verify.dart';
import 'package:a_reader/services/create_user.dart';
import 'package:a_reader/widgets/input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
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

    child: Form(
      key: _formKey,
      child: Column(children: [
        Text(
            'Please enter a valid email and a password that is at least 8 characters with one special characters, one uppercase and a number'),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? 'Please add an email' : null;
            },
            controller: _emailTextController,
            decoration: buildInputDecoration(
                label: 'Enter email', hintText: 'maha@gmail.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
          validator: (value) {
          RegExp regex =
          RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if (value.isEmpty) {
          return 'Please enter password';
         } else {
        if (!regex.hasMatch(value)) {
        return 'Enter valid password';
         } else {
        return null;
      }
    }
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
            style: TextButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                backgroundColor: Colors.amber,
                textStyle: TextStyle(fontSize: 18)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                String email = _emailTextController.text;
                //naina@me.com ['naina', 'me.com']
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: _passwordTextController.text)
                    .then((value) {
                  if (value.user != null) {
                    String displayName = email.toString().split('@')[0];
                    createUser(displayName, context).then((value) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email,
                              password: _passwordTextController.text)
                          .then((value) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyScreen(),
                            ));
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
                    });
                  }
                });
              }
            },
            child: Text('Create Account'))
      ]),
    ),
    );

  }
}
