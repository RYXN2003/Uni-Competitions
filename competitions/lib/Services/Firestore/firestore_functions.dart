import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitions/Classes/prize.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Upload a single doc to firestore
Future<void> uploadDoc({
  required String collection,
  required Map<String, dynamic> data,
  required String email,
  String? title}) async {
  // Uploads the given doc to the given collection
  await FirebaseFirestore.instance.collection(collection).doc(email).set(data);
} 
// Get a users data from the users collection
Future<Map<String,dynamic>?> userSearch(String email) async{
  // init the account data container
  Map<String,dynamic>? accountData = {};
  // get the current users account information
  final docRef = await FirebaseFirestore.instance.collection('Users').doc(email).get();
  accountData = docRef.data();
  // get the current amount of previous checkout sessions
  final currentCheckoutSessionsRef = await FirebaseFirestore.instance.collection('customers')
                                        .where('email', isEqualTo: email)
                                        .limit(1)
                                        .get();
  final currentPaymentsRef = await FirebaseFirestore.instance.collection('customers')
                                        .doc(currentCheckoutSessionsRef.docs[0].id)
                                        .collection('payments')
                                        .get();
  // Counts the number od docs in the payments doc
  final currentPaymentCount = currentPaymentsRef.size;
  print(currentPaymentCount);
  // check if the users previous checkout sessions has increased
 
  
  return accountData;
}
// Get the current list of prizes from firebase
Future<List<Prize>> getCurrentPrizes() async{
  List<Prize> prizeList = [];
  final docRef = await FirebaseFirestore.instance.collection('Prizes').get();
  for (var doc in docRef.docs){
    Prize prize = Prize(
      title: doc['Title'],
      imageUrl: doc['ImageUrl'], 
      ticketPrice: doc['TicketPrice'],
      ticketsSold: doc['TicketsSold'],
      totalTickets: doc['TotalTickets'],
      winnerCount: doc['WinnerCount']);
    prizeList.add(prize);
  }
  return prizeList;
}
// Get the data of a selected prize
Future<Map<String, dynamic>> getPrizeData({required String productName}) async{
  // Get the doc ref of the chosen product
  final prizeDocRef = await FirebaseFirestore.instance.collection('Prizes')
                  .where('Title', isEqualTo: productName).limit(1).get(); 
  final prizeDoc = prizeDocRef.docs.first;
  // Search for the prize in the product collection
  final productDocRef = await FirebaseFirestore.instance.collection('products')
                        .where('name', isEqualTo: prizeDoc['Title']).get();
  final productId = productDocRef.docs.first.id;
  
  Map<String, dynamic> prize = {
    'ProductData':  Prize(
    title: prizeDoc['Title'],
    imageUrl: prizeDoc['ImageUrl'],
    ticketPrice: prizeDoc['TicketPrice'],
    ticketsSold: prizeDoc['TicketsSold'],
      totalTickets: prizeDoc['TotalTickets'],
    winnerCount: prizeDoc['WinnerCount']
    ),
    'ProductId': productId
  };
    return prize;
}
// Create an information doc for a stripe checkout session
Future<String> createStripeCheckoutSession({required List<Map<String,dynamic>> basketItems})async{
  // Init list of products the user wants to buy
  final List<Map<String,dynamic>> lineItems = [];
  // Loop through the users basket items and add their propeties to a line item
  for (var item in basketItems){
    // Get the official price of the Stripe product
    final price = await FirebaseFirestore.instance.collection('products')
                .doc(item['ProductId']).collection('prices')
                .where('active', isEqualTo: true).limit(1).get();
    // Create a line item
    lineItems.add({
      "price": price.docs[0].id,
      "quantity": item['Quantity']
    });
  }
  
  // Create a checkout session and add it to the correct customers information
  final docRef = await FirebaseFirestore.instance.collection('customers')
                .doc(FirebaseAuth.instance.currentUser?.uid).collection('checkout_sessions')
                .add({
                  "line_items": lineItems,
                  "client": "web",
                  "mode": "payment",
                  "success_url":'http://localhost:51660/#/home',
                  "cancel_url": 'http://localhost:51660/#/home'
                });
  return docRef.id;
}
// Add product to basket
Future<void> addProductToBasket({required String productId,required int quantity, required String productName})async{
  // Add the product to the users basket doc
  await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.email)
  .collection('Basket')
  .add({
    'ProductId' : productId,
    'Quantity' : quantity,
    'ProductName': productName
  });
}
// Get a list of basket items from the users basket doc
Future<List<Map<String,dynamic>>> getItemsFromUserBasket()async{
  // init list 
  List<Map<String,dynamic>> basketItems = [];
  // get the doc ref of the users basket items
  final docRef = await FirebaseFirestore.instance.collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .collection('Basket')
                .get();
  // Append each basket item to list
  for (var doc in docRef.docs){
    basketItems.add(doc.data());
  }
  return basketItems;
}
// Send the customer to the depist checkout
Future<String> createDepositCheckoutSession(int quantity) async{
  // Get the price doc of the wallet funds product
    final price = await FirebaseFirestore.instance.collection('products')
                .doc('***').collection('prices')
                .where('active', isEqualTo: true).limit(1).get();
  // Create a checkout session and add it to the correct customers information
  final docRef = await FirebaseFirestore.instance.collection('customers')
                .doc(FirebaseAuth.instance.currentUser?.uid).collection('checkout_sessions')
                .add({
                  "price": price.docs[0].id,
                  "quantity": quantity,
                  "client": "web",
                  "mode": "payment",
                  "success_url":'***',
                  "cancel_url": '***'
                });
  return docRef.id;
}
