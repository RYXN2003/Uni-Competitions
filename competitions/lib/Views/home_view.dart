import 'package:competitions/Classes/prize.dart';
import 'package:competitions/Constants/font_sizes.dart';
import 'package:competitions/Utilities/key_widgets.dart';
import 'package:competitions/Utilities/percent_indicator.dart';
import 'package:competitions/Responsive/desktop_body.dart';
import 'package:competitions/Services/Auth/auth_service.dart';
import 'package:competitions/Services/Firestore/firestore_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key,});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Map<String,dynamic>? accountData;
  List<Prize> prizeList = [];
  bool isSignedIn = false;

  @override
  void initState() {
    checkSignedIn();
    getPrizeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
      builder:(context, constraints) {
        if(constraints.maxWidth < 600){
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
                  children: [
              // Top Navigation Bar
                topNavigationBar(isSignedIn, accountData, context),                         
              // Live competitions Heading
                Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(221, 24, 23, 23)
                    ),
                    child: 
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Live Competitions',
                              style: GoogleFonts.roboto(
                                fontSize: mobile_Heading1,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),), 
              // List of current prizes
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: prizeList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 2)
                            )],
                          borderRadius: BorderRadius.circular(15)
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: MediaQuery.of(context).size.height * 0.05
                        ),
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              'product',
                              pathParameters: {'productName': prizeList[index].title}
                            );
                          },
                          child: Column(
                            children: [
                              // Image and oticket slae indicator
                              Stack(
                                children: [
                                  // Prize Image
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)
                                        ),
                                        child: Image.network(
                                          prizeList[index].imageUrl,
                                          fit: BoxFit.cover,),
                                      ),
                                    ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: getPrizeIndicator(
                                        ticketsSold: prizeList[index].ticketsSold,
                                        totalTickets: prizeList[index].totalTickets
                                      ),
                                  ),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                              // Prize No of winners
                              Text(
                                '${prizeList[index].winnerCount} x winners',
                                style: GoogleFonts.roboto(
                                  fontSize: mobile_Text,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45
                                ),
                              ),
                              // Prize Title
                              Text(
                                prizeList[index].title,
                                style: GoogleFonts.roboto(
                                  fontSize: mobile_Heading1,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                              // Prize entry price
                              Text(
                                prizeList[index].ticketPrice,
                                style: GoogleFonts.roboto(
                                  fontSize: mobile_Heading2,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
              // How To Play Heading
                Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(221, 24, 23, 23)
                    ),
                    child: 
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'How To Play',
                              style: GoogleFonts.roboto(
                                fontSize: mobile_Heading1,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),),
              ]   
            ),
          );
        } 
        else{
          return const DesktopBody();
        }
      },)
    );
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
  Future<void> getPrizeList() async{
     // Get the list of current prize data
    await getCurrentPrizes().then((value) {
      setState(() {
        prizeList = value;
      });
    });
  }
}