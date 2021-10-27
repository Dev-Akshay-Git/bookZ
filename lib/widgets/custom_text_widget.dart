import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//custom text widget to adding padding with the text and keep the font family the same
class CustomText extends StatelessWidget {
  EdgeInsets padding;
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  CustomText(
      {Key? key,
      required this.text,
      this.fontSize = 24,
      this.color = Colors.black,
      this.padding = const EdgeInsets.all(5.0),
      this.fontWeight = FontWeight.w100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
