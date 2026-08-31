import 'package:competitions/Services/Firestore/firestore_functions.dart';
import 'package:competitions/Utilities/key_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Classes/prize.dart';
import '../Constants/font_sizes.dart';
import '../Services/Auth/auth_service.dart';

class ProductView extends StatefulWidget {
  
  const ProductView({super.key, required this.productName});
  final String productName;
  
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  late final Prize? productData;
  Map<String,dynamic>? accountData;
  var _productId = '';
  bool isSignedIn = false;
  final TextEditingController _quantity = TextEditingController();

  @override
  void initState() {
    checkSignedIn();
    getProductData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _productId.isEmpty ? const CircularProgressIndicator() : SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints){
            if(constraints.maxWidth < 600){
             return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                      Column(
                        children: [ 
                        // Top Navigation Bar                
                          topNavigationBar(isSignedIn, accountData, context),
                        // Product Section
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30)
                              )
                            ),
                            child: Column(
                              children: [
                              // Image and product details  
                                Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(30)
                                        ),
                                        color:Color(0xffebedf0),
                                      ),
                                      child: Column(
                                        children: [
                                        // Product Image
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.5,
                                            width: MediaQuery.of(context).size.width,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                bottom: Radius.circular(30)
                                              ),
                                              child: Image.network(
                                                productData!.imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        // Product Details
                                          Container(
                                            height: MediaQuery.of(context).size.height * 0.25,
                                            margin: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context).size.height * 0.02,
                                              horizontal: MediaQuery.of(context).size.width * 0.05
                                            ) ,
                                            child: Column(
                                              children: [
                                              // Product Title
                                                Row(
                                                  children: [
                                                    Text(
                                                      productData!.title,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: mobile_Title,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                                              // Product Price
                                                Row(
                                                  children: [
                                                    Text(
                                                      productData!.ticketPrice,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: mobile_Heading1,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.deepOrange
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                              // Product Description
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: 
                                                        Text(
                                                          'This prize consists of the all new airpods pro, ideal for listening to music or podcasts on the go. Each lucky winner will recieve a pair once the draw is complete',
                                                          style: GoogleFonts.roboto(
                                                            fontSize: mobile_Text,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.blueGrey
                                                          ),
                                                        ),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                              // Product highlights
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                  // Winner Count
                                                    Text(
                                                      'Possible Winners\n ${productData!.winnerCount}',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: mobile_Text,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black
                                                        ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const Divider(indent: 10, endIndent: 10,),
                                                  // Tickets Available
                                                    Text(
                                                      'Tickets Available\n ${productData!.totalTickets}',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: mobile_Text,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black
                                                        ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const Divider(indent: 10, endIndent: 10,),
                                                  // Tickets Sold
                                                    Text(
                                                      'Tickets Sold\n ${productData!.ticketsSold}',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: mobile_Text,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black
                                                        ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )                  
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              // Checkout Tab
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  margin: EdgeInsets.symmetric(
                                    vertical: MediaQuery.of(context).size.height * 0.02,
                                    horizontal: MediaQuery.of(context).size.width * 0.05
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.arrow_back_ios_new_rounded,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.08,
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
                                                  hintText: '1',
                                                  hintStyle: GoogleFonts.roboto(
                                                    color: const Color.fromARGB(255, 160, 158, 158)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add To Basket Button
                                        ElevatedButton(
                                          onPressed: () async { 
                                            // Add product to the basket of the user 
                                            await addProductToBasket(productId: _productId,
                                              quantity: 1, productName: productData!.title);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                            )
                                          ),
                                          child: Text(
                                            'Add To Basket',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                )                    
                              ],
                            ),
                          )
                        ],
                      ) 
                  ],
                ),
              );
            }
            else{
              return Column();
            }
          }
        )
      )
    );
  }
  // Get the data of the product selected
  Future<void> getProductData() async{
    await getPrizeData(productName: widget.productName)
    .then((value){
      setState(() {
        productData = value['ProductData'];
        _productId = value['ProductId'];
      });
    });
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