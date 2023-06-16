import 'package:child_io/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inpDec(
  String hintText,
  String labelText, {
  bool isSearch = false,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      color: textColor,
    ),
    prefixIcon: isSearch
        ? Icon(
            Icons.search,
            color: textColor,
          )
        : null,
    hintStyle: TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontSize: 13,
      color: textColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primaryColor),
    ),
  );
}
