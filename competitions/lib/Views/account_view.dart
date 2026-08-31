import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/font_sizes.dart';
import '../Services/Auth/auth_service.dart';
import '../Services/Firestore/firestore_functions.dart';
import '../Utilities/key_widgets.dart';
import 'Checkout_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Map<String, dynamic>? accountData;
  bool isSignedIn = false;
  final _quantity = TextEditingController();
  String _checkoutSessionId = '';
  List<Map<String,dynamic>> basketItems = [];

  @override
  void initState() {
    checkSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_checkoutSessionId.isEmpty){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600){
            return  !isSignedIn ? const CircularProgressIndicator() 
            : SingleChildScrollView(
              child: Column(
                children: [
                // Top Navigation Bar
                  topNavigationBar(isSignedIn, accountData, context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                // Wallet Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0.2,
                          blurRadius: 1,
                          offset: const Offset(0, 1)
                        )],
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                      // Padding
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      // Dummy account logo
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Image.network(
                            'data:image/png;base64,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',
                            fit: BoxFit.cover,
                          ),
                        ),
                      // Username  
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              accountData!['Username'],
                              style: GoogleFonts.roboto(
                                  fontSize: mobile_Heading1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                                ),
                            )
                          ],
                        ),
                      // Padding
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      // Account balance
                        Text(
                          '£${accountData!['Balance'].toString()}.00',
                          style: GoogleFonts.roboto(
                              fontSize: mobile_Heading1,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
                        ),
                      // Add funds 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: TextField(
                                controller: _quantity,
                                textAlign: TextAlign.center,
                                enableSuggestions: false,
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: mobile_Heading3
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none
                                  ),
                                  hintText: '£1',
                                  hintStyle: GoogleFonts.roboto(
                                    color: const Color.fromARGB(255, 160, 158, 158)
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async { 
                                // Send the user to checkout 
                                await createDepositCheckoutSession(int.parse(_quantity.text))
                                .then((value) {
                                  setState(() => _checkoutSessionId = value);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                )
                              ),
                              child: Text(
                                'Add Funds',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: mobile_Heading2,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          else{
            return Text('Web');
          }
        }
      ),
    );
    }else{
      return Checkout(checkoutSessionId: _checkoutSessionId);
    }
  }
  // Check the user is signed in, if so grab profile data
  Future<void> checkSignedIn() async{
    // Search for the user in the users collection
    if (AuthService.firebase().currentUser != null) {
      // Read the users account data from firebase
      await userSearch(AuthService.firebase().currentUser!.email)
      .then((value) {
        setState(() {
          accountData = value;
          isSignedIn = true;
        });
      });
    }
  }
}