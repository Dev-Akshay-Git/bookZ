import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  late FirebaseFirestore firestore;
  Map Userbooks = {'BooksName': [], 'URLs': []};

  initialize() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List doc = [];
    try {
      querySnapshot = await firestore.collection("Books").get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var docs in querySnapshot.docs.toList()) {
          Map books = {
            'id': docs.id,
            'book_name': docs['Name'],
            'author_name': docs['Author'],
            'rating': docs['rating'],
            'price': docs['Price']
          };
          doc.add(books);
        }
        return doc;
      } else {
        return doc;
      }
    } catch (e) {
      print("$e");
      doc.add(e);
      return doc;
    }
  }

  Future<List> readFromUser() async {
    List userRepoBooks = [];
    List bookNames = [];
    List bookUrl = [];
    QuerySnapshot querySnapshot;
    try {
      SharedPreferences user = await SharedPreferences.getInstance();
      print("${user.getString("UserID")}");
      querySnapshot = await firestore
          .collection("BoughtBooks")
          .where("UserID", isEqualTo: user.getString("UserID"))
          .get();
      for (var docs in querySnapshot.docs.toList()) {
        Map boughtbooks = {
          'id': docs.id,
          'book_id': docs['BookID'],
          'UserID': docs['UserID'],
        };
        userRepoBooks.add(boughtbooks);
      }
      for (int i = 0; i < userRepoBooks.length; i++) {
        querySnapshot = await firestore
            .collection("Books")
            .where("BookID", isEqualTo: userRepoBooks[i]["book_id"])
            .get();
        for (var docs in querySnapshot.docs.toList()) {
          Map boughtbooks = {
            'id': docs.id,
            'book_name': docs['Name'],
            'book_id': docs['BookID'],
            'Author': docs['Author'],
            'rating': docs['rating'],
            'price': docs['Price'],
            'url': docs["URL"]
          };
          bookNames.add(boughtbooks['book_name']);
          bookUrl.add(boughtbooks['url']);
          Userbooks['BooksName'] = bookNames;
          Userbooks['URLs'] = bookUrl;
          print(bookNames);
          print(Userbooks);
        }
      }
      return bookNames;
    } catch (e) {
      print("$e");
      userRepoBooks.add(e);
      return bookNames;
    }
  }

  returnUserBooksAndNames() {
    return Userbooks;
  }

  getBookDetails(book) async {
    print("$book");
    QuerySnapshot querySnapshot = await firestore
        .collection("Books")
        .where("Name", isEqualTo: book)
        .get();
    Map? books;
    for (var docs in querySnapshot.docs.toList()) {
      books = {
        'id': docs.id,
        'book_name': docs['Name'],
        'book_id': docs['BookID'],
        'Author': docs['Author'],
        'rating': docs['rating'],
        'price': docs['Price'],
        'url': docs["URL"]
      };
      print("this is $books");
    }
    return books;
  }

  updateRating(rating, bookName) async {
    var overallRating, docID;
    QuerySnapshot querySnapshot = await firestore
        .collection("Books")
        .where("Name", isEqualTo: "$bookName")
        .get()
        .catchError((error) => print('Failed: $error'));
    for (var docs in querySnapshot.docs.toList()) {
      Map books = {
        'id': docs.id,
        'book_name': docs['Name'],
        'book_id': docs['BookID'],
        'Author': docs['Author'],
        'rating': docs['rating'],
        'price': docs['Price'],
        'url': docs["URL"]
      };
      overallRating = books['rating'];
      docID = books['id'];
      print(overallRating);
    }
    var totalRating = rating + overallRating / 2;
    try {
      await firestore
          .collection("Books")
          .doc('$docID')
          .update({'rating': totalRating})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } catch (e) {
      print(e);
    }
  }

  buyBook(bookid) async {
    var rng = new Random();

    var userID = await SharedPreferences.getInstance();
    String? user = userID.getString("UserID");
    DocumentReference<Map<String, dynamic>> users = FirebaseFirestore.instance
        .collection('BoughtBooks')
        .doc("${rng.nextInt(100)}");
    var myJSONObj = {
      "BookID": bookid,
      "UserID": "$user",
    };
    users
        .set(myJSONObj)
        .then((value) => print("User with CustomID added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
