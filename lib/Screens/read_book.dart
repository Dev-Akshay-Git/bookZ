import 'package:bookz/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadBook extends StatelessWidget {
  ReadBook({this.url, this.bookName});
  String? url, bookName;
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            bookName!,
            style: GoogleFonts.lobster(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Color.fromRGBO(237, 128, 38, 1),
        ),
        body: Center(child: Container(child: SfPdfViewer.network(url!))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showRatingAppDialog(context);
          },
          child: Icon(Icons.star),
        ));
  }

  void _showRatingAppDialog(BuildContext context) {
    final _ratingDialog = RatingDialog(
      enableComment: false,
      title: Text("Rating for the book"),
      submitButtonText: "Submit",
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}');
        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
        db.initialize();
        db.updateRating(response.rating, bookName);
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}
