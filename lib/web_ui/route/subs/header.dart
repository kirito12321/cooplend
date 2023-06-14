import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderText extends StatefulWidget {
  String subTtl, Ttl;
  HeaderText({
    super.key,
    required this.subTtl,
    required this.Ttl,
  });

  @override
  State<HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),

      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.black),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subTtl,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            widget.Ttl,
            style: GoogleFonts.montserrat(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 0.3,
            ),
          )
        ],
      ),
    );
  }
}
