import 'dart:io';
import 'dart:convert';
import 'package:nostr_tools/nostr_tools.dart';
import 'aes_utils.dart';

Future<void> sendFile() async {
  print("Enter nsec:");
  String? nsec = stdin.readLineSync();
  if (nsec == null || nsec.isEmpty) {
    print("Error: nsec cannot be empty.");
    return;
  }

  print("Enter file path:");
  String? filePath = stdin.readLineSync();
  if (filePath == null || filePath.isEmpty) {
    print("Error: File path cannot be empty.");
    return;
  }

  print("Enter password:");
  String? password = stdin.readLineSync();
  if (password == null || password.isEmpty) {
    print("Error: Password cannot be empty.");
    return;
  }

  final nip19 = Nip19();
  final relay = RelayApi(relayUrl: 'wss://relay.damus.io');
  final aes = AES256CTR(password);

  try {
    final file = File(filePath);
    final fileName = file.uri.pathSegments.last;
    final fileBytes = await file.readAsBytes();
    final base64Content = base64Encode(fileBytes);

    final encryptedContent = aes.encrypt("$fileName::$base64Content");
    var decodedNsec = nip19.decode(nsec)['data'];
    final stream = await relay.connect();

    final event = EventApi().finishEvent(
      Event(
        kind: 1,
        tags: [],
        content: encryptedContent,
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
      decodedNsec,
    );

    relay.publish(event);
    print('Encrypted file sent to relay: ${nip19.noteEncode(event.id)}');

    stream.listen((Message message) {
      print('Response from relay: ${message.message}');
    });

    await Future.delayed(Duration(seconds: 10));
    relay.close();
    print('Connection closed.');
  } catch (e) {
    print('Error while sending file: $e');
  }
}

void main() {
  sendFile();
}
