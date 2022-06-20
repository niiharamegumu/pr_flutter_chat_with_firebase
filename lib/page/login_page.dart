import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfirebasechatapp/store/user_store.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoText = ref.watch(infoTextProvider.state).state;
    final email = ref.watch(emailProvider.state).state;
    final password = ref.watch(passwordProvider.state).state;

    Future registeUser() async {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result.user != null) {
          ref.read(userProvider.state).state = result.user;
          context.go('/chat');
        }
      } on FirebaseAuthException catch (e) {
        ref.read(infoTextProvider.state).state =
            'ユーザー登録に失敗しました...${e.toString()}';
        return null;
      }
    }

    Future loginUser() async {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential result = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result.user != null) {
          ref.read(userProvider.state).state = result.user;
          context.go('/chat');
        }
      } on FirebaseAuthException catch (e) {
        ref.read(infoTextProvider.state).state =
            'ログインに失敗しました...${e.toString()}';
        return null;
      }
    }

    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'メールアドレス'),
              onChanged: (String val) {
                ref.read(emailProvider.state).state = val;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'パスワード'),
              onChanged: (String val) {
                ref.read(passwordProvider.state).state = val;
              },
            ),
            Container(
              padding: const EdgeInsets.all(8),
              // メッセージ表示
              child: Text(infoText),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('ユーザー登録'),
                onPressed: () async {
                  await registeUser();
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  await loginUser();
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
