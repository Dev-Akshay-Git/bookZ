import 'package:bookz/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  BookCard({Key? key, required this.name, this.onTap}) : super(key: key);
  String name;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.grey,
      child: Column(
        children: [
          Image.asset("assets/images/43122.jpg"),
          CustomText(
            text: name,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
