
import 'package:a_reader/screens/get_started_page.dart';
import 'package:a_reader/screens/login_page.dart';
import 'package:a_reader/screens/main_screen.dart';
import 'package:a_reader/screens/page_not_found.dart';
import 'package:a_reader/widgets/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          initialData: null,
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        )
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'A_Reader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
                home: SplashScreen(),

        initialRoute: '/',
        onGenerateRoute: (settings) {
          print(settings.name);
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingName: settings.name);
            },
          );
        
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return PageNotFound();
            },
          );
        },
      ),
    );
  }
}

class TesterApp extends StatelessWidget {
  const TesterApp({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final bookListStream = snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).toList();

              for (var item in bookListStream) {
                print(item.notes);
              }
              return ListView.builder(
                itemCount: bookListStream.length,
                itemBuilder: (context, index) {
                  return Text(bookListStream[index].author);
                },
              );
            },
          ),
        ));
  }
}

class RouteController extends StatelessWidget {
  final String settingName;

  const RouteController({Key key, this.settingName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;

    final signedInGotoMain =
        userSignedIn && settingName == '/main'; // they are good to go!
    final notSignedIngotoMain = !userSignedIn &&
        settingName == '/main'; // not signed in user trying to to the mainPage
    if (settingName == '/') {
      return GetStartedPage();
    } else if (settingName == '/login' || notSignedIngotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainScreenPage();
    } else {     
      return PageNotFound();
    }
  }
}
