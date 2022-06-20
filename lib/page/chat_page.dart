import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfirebasechatapp/store/user_store.dart';
import 'package:go_router/go_router.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.state).state;

    Future logout() async {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signOut();
        context.go('/login');
      } on FirebaseAuthException catch (e) {
        ref.read(infoTextProvider.state).state =
            'ログアウトに失敗しました...${e.toString()}';
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user!.email}さん',
          style: const TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Text(
              '投稿内容',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('date')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                            title: Text(document['text']),
                            subtitle: Text(document['email']),
                            trailing: document['email'] == user.email
                                ? IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(document.id)
                                          .delete();
                                    },
                                    icon: const Icon(Icons.delete))
                                : null),
                      );
                    }).toList());
              }
              return const Center(
                child: Text('読込中...'),
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go('/addPost');
        },
      ),
    );
  }
}
