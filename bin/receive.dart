import 'dart:io';
import 'dart:convert';
import 'package:nostr_tools/nostr_tools.dart';
import 'aes_utils.dart';

String nip19ToHex(String nip19Id) {
  final nip19 = Nip19();
  var decodedNote = nip19.decode(nip19Id);
  return decodedNote['data'];
}

Future<void> fetchAndDecryptFile(String nip19NoteId, String password) async {
  String noteId = nip19ToHex(nip19NoteId);
  final relay = RelayApi(relayUrl: 'wss://relay.damus.io');
  final stream = await relay.connect();
  final aes = AES256CTR(password);

  relay.sub([
    Filter(
      kinds: [1],
      ids: [noteId],
      limit: 1,
    )
  ]);

  await for (Message message in stream) {
    if (message.type == 'EVENT') {
      Event event = message.message;

      try {
        var decryptedContent = aes.decrypt(event.content);

        final parts = decryptedContent.split('::');
        final fileName = parts[0];
        final base64Content = parts[1];

        print("Enter the directory where you want to save the file:");
        String? saveDirectory = stdin.readLineSync();

        if (saveDirectory != null && saveDirectory.isNotEmpty) {
          var fileBytes = base64Decode(base64Content);
          await File("$saveDirectory/$fileName").writeAsBytes(fileBytes);
          print('File decrypted and saved as $saveDirectory/$fileName');
        } else {
          print("No directory specified. File not saved.");
        }
      } catch (e) {
        print('Failed to decrypt or save file: $e');
      }

      break;
    }
  }

  relay.close();
  print('Connection closed.');
}

void main() async {
  print("Enter Note ID:");
  String? noteId = stdin.readLineSync();

  print("Enter password:");
  String? password = stdin.readLineSync();

  await fetchAndDecryptFile(noteId!, password!);
}
