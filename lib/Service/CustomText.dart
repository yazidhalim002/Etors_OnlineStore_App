import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;

  final Alignment alignment;

  final int maxLine;
  final double height;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;

  CustomText({
    this.text = '',
    this.fontSize = 14,
    this.color = Colors.black,
    this.alignment = Alignment.topLeft,
    this.maxLine = 1,
    this.height = 1,
    this.textDecoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: color,
            height: height,
            fontSize: fontSize,
            decoration: textDecoration,
            fontWeight: fontWeight),
        maxLines: maxLine,
      ),
    );
  }
}

class FaqText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;

  final Alignment alignment;

  final double height;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;

  FaqText({
    this.text = '',
    this.fontSize = 14,
    this.color = Colors.black,
    this.alignment = Alignment.topLeft,
    this.height = 1,
    this.textDecoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: color,
            height: height,
            fontSize: fontSize,
            decoration: textDecoration,
            fontWeight: fontWeight),
      ),
    );
  }
}
