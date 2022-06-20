import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

final infoTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

final passwordProvider = StateProvider.autoDispose((ref) {
  return '';
});

final messageTextProvider = StateProvider.autoDispose((ref) {
  return '';
});
final displayNameProvider = StateProvider.autoDispose((ref) {
  return '';
});
