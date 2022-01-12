// ignore_for_file: public_member_api_docs

import 'package:about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;

    final aboutPage = AboutPage(
      values: {
        'version': '1.0.0+1',
        'buildNumber': '1',
        'year': '2022',
        'author': 'Maha Lakshmi and Nayana',
      },
      title: const Text('About'),
      applicationVersion: 'Version {{ version }}, build #{{ buildNumber }}',
      applicationDescription: const Text('This Application fetches the books from Google Books APIs. Developed using flutter, environment sdk: ">=2.11.0 <3.0.0". Get any book you want at one tap. Always Crave Learning. ',
        textAlign: TextAlign.justify,
      ),
      applicationIcon: const FlutterLogo(size: 100),
      applicationLegalese: 'Copyright © {{ author }}, {{ year }}',
     
    );

    if (isIos) {
      return CupertinoApp(
        title: 'About',
        home: aboutPage,
        debugShowCheckedModeBanner: false,

        theme: CupertinoThemeData(
          brightness: theme.brightness,
          
        ),
      );
    }

    return MaterialApp(
      title: 'About',
      home: aboutPage,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primarySwatch: Colors.deepOrange,

      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}