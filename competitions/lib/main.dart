import 'package:competitions/Views/account_view.dart';
import 'package:competitions/Views/basket_view.dart';
import 'package:competitions/Views/home_view.dart';
import 'package:competitions/Views/login_view.dart';
import 'package:competitions/Views/product_page_view.dart';
import 'package:competitions/Views/register_view.dart';
import 'package:competitions/Views/verify_email_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "***",
      authDomain: "***",
      projectId: "***",
      storageBucket: "***",
      messagingSenderId: "***",
      appId: "***",
      measurementId: "***"
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, GoRouterState state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, GoRouterState state) {
          return const RegisterView();
        },
      ),
      GoRoute(
        path: '/verify',
        builder: (context, GoRouterState state) {
          return const VerifyEmailView();
        },
      ),
      GoRoute(
        name: 'product',
        path: '/product/:productName',
        builder: (context, state) => ProductView(
          productName: state.pathParameters['productName']!,
        )
      ),
      GoRoute(
        path: '/basket',
        builder: (context, GoRouterState state) {
          return const BasketView();
        },
      ),
      GoRoute(
      path: '/account',
      builder: (context, GoRouterState state) {
        return const AccountView();
      },
    ),
    ]);
  
  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    );
  }
}


