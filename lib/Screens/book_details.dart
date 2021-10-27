import 'package:bookz/services/database.dart';
import 'package:bookz/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDetails extends StatelessWidget {
  var bookName;
  Map? details;
  Database db = Database();

  BookDetails({Key? key, required this.bookName, this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$bookName",
          style: GoogleFonts.lobster(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Color.fromRGBO(237, 128, 38, 1),
      ),
      body: Column(
        children: [
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/43122.jpg'))),
          )),
          const SizedBox(height: 10),
          CustomText(
            text: "Author: ${details!["Author"]}",
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: double.parse(details!["rating"].toString()),
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (double value) {},
          ),
          const SizedBox(height: 10),
          CustomText(
              fontSize: 18,
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "),
          ElevatedButton(
              onPressed: () {
                _showDialog(
                    "Are you sure?", "You want to buy ${bookName}", context);
              },
              child: Text("Buy the book")),
        ],
      ),
    );
  }

  _showDialog(title, text, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              text: title,
              fontWeight: FontWeight.bold,
            ),
            content: CustomText(
              text: text,
              fontSize: 18,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  db.buyBook(details!['book_id']);
                  const snackBar = SnackBar(
                    content: Text('you bought a book'),
                  );
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                child: CustomText(
                  text: "Buy for \u{20B9}${details!["price"]}",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              )
            ],
          );
        });
  }
}
