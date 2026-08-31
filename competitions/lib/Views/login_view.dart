// ignore_for_file: use_build_context_synchronously
import 'package:competitions/Constants/routes.dart';
import 'package:competitions/Services/Auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/Auth/auth_exceptions.dart';
import '../Utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
   @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                  'SIGN IN',
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
                    ],
                  ),
                ),
                // Log In Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try{
                        // Attempts to sign in with the credentials inputed
                          await AuthService.firebase().logIn(email: email, password: password);
                        // Get the user credentials
                          final user = AuthService.firebase().currentUser;
                        // Check if they have verified email
                          if (user?.isEmailVerified ?? false)
                          {
                            // user is verified
                            context.go('/home');
                          }
                          else
                          { 
                            // user isn't verified
                            context.go('/verify');
                          }
                        }
                        on UserNotFoundAuthException
                        {
                          await showErrorDialog(context, 'User Not Found');
                        }
                        on WrongPasswordAuthException
                        {
                          await showErrorDialog(context, 'Wrong Credentials');
                        }
                        on GenericAuthException
                        {
                          await showErrorDialog(context, 'Authentication Error');
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
                        'Log In',
                        style: 
                        GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                // Register Now Option
                  Text(
                    '''Don't Have An Account?''',
                    style: GoogleFonts.roboto(
                      fontSize: 15
                    ),
                  ),
                // Sign Up Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        // user isn't verified
                            context.go('/sign-up');
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