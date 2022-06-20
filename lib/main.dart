import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfirebasechatapp/page/add_post_page.dart';
import 'package:flutterfirebasechatapp/page/chat_page.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:flutterfirebasechatapp/page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: ChatApp()));
}

class ChatApp extends StatelessWidget {
  ChatApp({Key? key}) : super(key: key);

  final _router = GoRouter(initialLocation: '/login', routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
    GoRoute(path: '/addPost', builder: (context, state) => const AddPostPage())
  ]);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );
}
