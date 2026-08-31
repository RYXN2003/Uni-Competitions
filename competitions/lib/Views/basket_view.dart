import 'package:competitions/Utilities/key_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/Auth/auth_service.dart';
import '../Services/Firestore/firestore_functions.dart';
import 'Checkout_view.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {

  String _checkoutSessionId = '';
  Map<String,dynamic>? accountData;
  List<Map<String,dynamic>> basketItems = [];
  bool isSignedIn = false;

  @override
  void initState() {
    checkSignedIn();
    getBasketItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_checkoutSessionId.isEmpty) {
      return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600){
              return Column(
              children: [
              // Top Navigation Bar
                topNavigationBar(isSignedIn, accountData, context),
              // Page Title
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.025,
                    horizontal: MediaQuery.of(context).size.width * 0.1
                  ),
                  child: Text(
                    'My Basket',
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),
                ),
              // Product List
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: basketItems.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 2)
                          )],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            // Product Name
                              Text(
                                basketItems[index]['ProductName'],
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20
                                ),
                              ),
                            // Product Quantity
                              Text(
                                'x${basketItems[index]['Quantity']}',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Checkout Button
                ElevatedButton(
                  onPressed: () async { 
                    // Create a checkout session in Stripe
                    await createStripeCheckoutSession(basketItems: basketItems)
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
                    'Checkout',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],);
            }
           else{
              return const Scaffold();
            }
          },
        ),
      );
    } else {
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
  // Get all the items from the users basket
  Future<void> getBasketItems() async{
    // Fetch a list of basket items from the users doc
      await getItemsFromUserBasket().then((value) {
        setState(() {
          basketItems = value;
        });
      });
      print(basketItems);
  }
}