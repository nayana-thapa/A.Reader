import 'package:a_reader/constants/constants.dart';
import 'package:a_reader/model/book.dart';
import 'package:a_reader/model/user.dart';
import 'package:a_reader/screens/login_page.dart';
import 'package:a_reader/widgets/about.dart';
import 'package:a_reader/widgets/book_details_dialog.dart';
import 'package:a_reader/widgets/book_search_page.dart';
import 'package:a_reader/widgets/create_profile.dart';
import 'package:a_reader/widgets/reading_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreenPage extends StatefulWidget {
  @override
  _MainScreenPageState createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
    String email="thapanayana02@gmail.com";

  

  @override
  Widget build(BuildContext context) {
    CollectionReference userCollectionReference =
        FirebaseFirestore.instance.collection('users');
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    List<Book> userBooksReadList = [];

    var authUser = Provider.of<User>(context);
    
    

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
    new Scaffold(
      
      appBar: AppBar(
        
        backgroundColor: Colors.white24,
        iconTheme: IconThemeData(color: Colors.redAccent),
        elevation: 0.0,
        toolbarHeight: 77,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/Icon-76.png',
              scale: 2,
            ),
            Text(
              'A.Reader',
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        
        actions: [
          (authUser != null)
              ? StreamBuilder<QuerySnapshot>(
                  stream: userCollectionReference.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final userListStream = snapshot.data.docs.map((user) {
                      return MUser.fromDocument(user);
                    }).where((user) {
                      return (user.uid == authUser.uid);
                    }).toList(); //[user]

                    MUser curUser = userListStream[0];

                    return Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  curUser.avatarUrl != null
                                      ? curUser.avatarUrl
                                      : 'https://i.pravatar.cc/300'),
                              backgroundColor: Colors.white,
                              child: Text(''),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  // return createProfileMobile(context, userListStream,
                                  //     FirebaseAuth.instance.currentUser, null);
                                  return createProfileDialog(
                                      context, curUser, userBooksReadList);
                                },
                              );
                            },
                          ),
                        ),
                        Text(
                          curUser.displayName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    );
                  },
                )
              : Container(),
          TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }, onError: (error) {
                  print(error.toString());
                });
              },
              icon: Icon(Icons.logout),
              label: Text(''))
        ],
      ),
      
      drawer: Drawer(
        
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("A Reader",style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                backgroundImage: AssetImage('assets/images/Icon-76.png'),
              ),
              decoration: BoxDecoration(
                  color: Color(0xFF26667d),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/Icon-76.png'))),
            ),
           
            ListTile(
                title: Text('Extras',style: TextStyle(fontWeight: FontWeight.w300),),
            ),
            ListTile(
              
              leading: Icon(Icons.info_sharp),
              title: Text('About'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                ),
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review_sharp),
              title: Text('Leave a review'),
              onTap: () {
                launch('mailto:' + email);

              },
            ),
            ListTile(
              leading: Icon(Icons.share_sharp),
              title: Text('Tell a friend'),
              onTap: () =>{
                Share.share('This application helps you to get any books from Google Library. \n If you want this application, click the link below: \n https://drive.google.com/file/d/1YaOBoNsbtVtc2DaAaoluQ1_PXueYqvag/view?usp=sharing',
                    subject: 'A.Reader'),
              },
            ),
          ],
        ),
      ),
      
      
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSearchPage(),
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: 
      
      Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, left: 12, bottom: 10),
            width: double.infinity,
            child: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.headline5,
                    children: [
                  TextSpan(text: 'Your reading\n activity '),
                  TextSpan(
                      text: 'right now...',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ])),
          ),
          SizedBox(
            height: 10,
          ),
          (authUser != null)
              ? StreamBuilder<QuerySnapshot>(
                  stream: bookCollectionReference.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var userBookFilteredReadListStream =
                        snapshot.data.docs.map((book) {
                      return Book.fromDocument(book);
                    }).where((book) {
                      return (book.userId == authUser.uid) &&
                          (book.finishedReading == null) &&
                          (book.startedReading != null);
                    }).toList();

                    userBooksReadList = snapshot.data.docs.map((book) {
                      return Book.fromDocument(book);
                    }).where((book) {
                      return (book.userId == authUser.uid) &&
                          (book.finishedReading != null) &&
                          (book.startedReading != null);
                    }).toList();
                    //  booksRead = userBooksReadList.length;

                    return Expanded(
                      flex: 1,
                      child: (userBookFilteredReadListStream.length > 0)
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: userBookFilteredReadListStream.length,
                              itemBuilder: (context, index) {
                                Book book =
                                    userBookFilteredReadListStream[index];

                                return InkWell(
                                  child: ReadingListCard(
                                    rating: book.rating != null
                                        ? (book.rating)
                                        : 4.0,
                                    buttonText: 'Reading',
                                    title: book.title,
                                    author: book.author,
                                    image: book.photoUrl,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BookDetailsDialog(
                                          book: book,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                  'You haven\'t started reading. \nStart by adding a book.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ))),
                    );
                  },
                )
              : Container(),
          Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Reading List',
                          style: TextStyle(
                              color: kBlackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ])),
                  )
                ],
              )),
          SizedBox(
            height: 8,
          ),
          (authUser != null)
              ? StreamBuilder<QuerySnapshot>(
                  stream: bookCollectionReference.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var readingListListBook = snapshot.data.docs.map((book) {
                      return Book.fromDocument(book);
                    }).where((book) {
                      return (book.userId == authUser.uid) &&
                          (book.finishedReading == null) &&
                          (book.startedReading == null);
                    }).toList();

                    return Expanded(
                        flex: 1,
                        child: (readingListListBook.length > 0)
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: readingListListBook.length,
                                itemBuilder: (context, index) {
                                  Book book = readingListListBook[index];

                                  return InkWell(
                                    child: ReadingListCard(
                                        buttonText: 'Not Started',
                                        rating: book.rating != null
                                            ? (book.rating)
                                            : 4.0,
                                        author: book.author,
                                        image: book.photoUrl,
                                        title: book.title),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          BookDetailsDialog(book: book),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No books found. Add a book :)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ))));
                  },
                )
              : Container()
        ],
      ),
      
    )
    );
  }
}
