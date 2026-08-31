import 'package:competitions/Constants/routes.dart';
import 'package:competitions/Services/Firestore/firestore_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/Auth/auth_exceptions.dart';
import '../Services/Auth/auth_service.dart';
import '../Utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }
   @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
        'UniCompetitions',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 15)
                )
              ]
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.1
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Text(
                  'SIGN UP',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.normal
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    // Email Textfield
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: _email,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 15
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 239, 241, 242),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                            ),
                            hintText: 'e.g. user@gmail.com',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 160, 158, 158)
                            ),
                            suffixIcon: const Icon(Icons.email),
                            suffixIconColor: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      Text(
                        'Password:',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    // Password Textfield
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: _password,
                          enableSuggestions: false,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 15
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 239, 241, 242),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                            ),
                            hintText: 'e.g. Password12345',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 160, 158, 158)
                            ),
                            suffixIcon: const Icon(Icons.password),
                            suffixIconColor: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      Text(
                        'Username:',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    // Username Texfield
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: _username,
                          enableSuggestions: false,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 15
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 239, 241, 242),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                            ),
                            hintText: 'e.g. CoolGuy69',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 160, 158, 158)
                            ),
                            suffixIcon: const Icon(Icons.person),
                            suffixIconColor: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Sign Up Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        try 
                        {
                          // Registering the user with email and password
                          await AuthService.firebase().createUser
                          (email: _email.text, password: _password.text);
                          // Send email verification
                          await AuthService.firebase().sendEmailVerification();
                          // Create a new user doc in users collection
                          await uploadDoc(collection: 'Users', data: {
                            'Username': _username.text,
                            'Balance': 0,
                            'SignInStatus': false
                          }, email: _email.text); 
                          // Navigate to verify email view
                          // ignore: use_build_context_synchronously
                          context.go('/verify');
                        }
                        // possible exceptions when registering 
                        on WeakPasswordAuthException
                        {
                          await showErrorDialog(context, 'Weak password');
                        }
                        on EmailAlreadyInUseAuthException
                        {
                          await showErrorDialog(context, 'Email already in use');
                        }
                        on InvalidEmailAuthException
                        {
                          await showErrorDialog(context, 'Invalid email address');
                        }
                        on GenericAuthException
                        {
                          await showErrorDialog(context, 'Registation Error');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                      child: Text(
                        'Sign Up',
                        style: 
                        GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}