import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfirebasechatapp/store/post_store.dart';
import 'package:flutterfirebasechatapp/store/user_store.dart';
import 'package:go_router/go_router.dart';

class AddPostPage extends ConsumerWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.state).state!;
    final postText = ref.watch(postTextProvider.state).state;

    Future postMessage() async {
      final date = DateTime.now().toLocal().toIso8601String();
      final email = user.email;
      await FirebaseFirestore.instance
          .collection('posts')
          .doc()
          .set({'email': email, 'text': postText, 'date': date});

      context.go('/chat');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規投稿'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: '投稿内容'),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                onChanged: (String val) {
                  ref.read(postTextProvider.state).state = val;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('投稿'),
                  onPressed: () async {
                    await postMessage();
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text('キャンセル'),
                  onPressed: () {
                    context.go('/chat');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
