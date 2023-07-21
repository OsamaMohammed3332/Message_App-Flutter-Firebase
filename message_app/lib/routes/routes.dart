import 'package:flutter/material.dart';
import 'package:message_app/screens/chat_screen.dart';
import 'package:message_app/screens/registeration_screen.dart';
import 'package:message_app/screens/signin_screen.dart';
import 'package:message_app/screens/welcome_screen.dart';

class RouteManager {
  static const String homePage = '/';
  static const String registerPage = '/register_page';
  static const String signingPage = '/signing_page';
  static const String chatPage = '/chat_page';



  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const RegistrationScreen(),
        );
      case signingPage:
        return MaterialPageRoute(
          builder: (context) => const SingingScreen(),
        );
      case chatPage:
        return MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        );
      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
