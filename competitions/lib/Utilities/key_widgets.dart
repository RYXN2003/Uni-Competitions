import 'package:competitions/Constants/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

Widget topNavigationBar(bool isSignedIn, Map<String,dynamic>? accountData, BuildContext context){
  return Material(
    elevation: 4,
    child: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          // Title
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Text(
                'UniCompetitions',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: mobile_Title
              ),),
            ),
          // Info
            Row(
              children: [
              // Basket
                GestureDetector(
                  onTap: () => context.go('/basket'),
                  child: Visibility(
                    visible: isSignedIn,
                    child: const Icon(
                    Icons.shopping_basket,
                    size: mobile_Title,
                    ),),
                ),
              // Sign in
                GestureDetector(
                  onTap: () {
                      !isSignedIn ? context.go('/login') : context.go('/account');
                    },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.025),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(221, 24, 23, 23),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: const Offset(0, 1)
                      )],
                      borderRadius: BorderRadius.circular(3)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                            Text(
                              !isSignedIn ? 'Login' : '£${accountData!['Balance']}.00',
                              style: GoogleFonts.roboto(
                                fontSize: mobile_Text,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            const Icon(
                              Icons.person,
                              size: mobile_Title,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}