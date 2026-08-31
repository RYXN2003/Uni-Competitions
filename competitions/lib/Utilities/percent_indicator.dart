import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

  Widget getPrizeIndicator({required int ticketsSold, required int totalTickets}){
    // Calculate the progress in percent
    final double percent = ticketsSold / totalTickets;
    // Create Displayed percentage
    final int displayPercent = (percent * 100).toInt();
    // Create the percentage widget
    return CircularPercentIndicator(
      radius: 40,
      lineWidth: 10,
      percent: percent,
      progressColor: Colors.green[400],
      backgroundColor: Colors.green.shade200,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        '${displayPercent.toString()}%',
        style: GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,)
    );
  }
