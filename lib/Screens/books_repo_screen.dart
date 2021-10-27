import 'package:bookz/services/database.dart';
import 'package:bookz/widgets/book_card.dart';
import 'package:bookz/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'book_details.dart';

class BooksRepo extends StatefulWidget {
  BooksRepo({Key? key}) : super(key: key);

  @override
  State<BooksRepo> createState() => _BooksRepoState();
}

class _BooksRepoState extends State<BooksRepo> {
  late Database db;
  List docs = [];
  initialize() async {
    db = Database();
    await db.initialize();
    await db.read().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "BookZ",
            style: GoogleFonts.lobster(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Color.fromRGBO(237, 128, 38, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomText(
                text: "Buy a Book",
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(116, 169, 56, 0.7),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(179, 179, 179, 1),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: books(),
                ),
              ),
            ],
          ),
        ));
  }

  books() {
    List<Widget> list = [];
    for (var value in docs) {
      Map book = value;
      list.add(InkWell(
          onTap: () async {
            Map result = await db.getBookDetails(book["book_name"]);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookDetails(
                      details: result,
                      bookName: book["book_name"],
                    )));
          },
          child: BookCard(name: book["book_name"])));
    }
    return list;
  }
}
