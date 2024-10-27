import 'dart:io';

void main() async {
  print('\x1B[35mWelcome to Drivestr!\x1B[0m');
  print("Choose an action: (s)end or (r)eceive");
  String? choice = stdin.readLineSync()?.toLowerCase();

  if (choice == 's') {
    await runSend();
  } else if (choice == 'r') {
    await runReceive();
  } else {
    print("Invalid choice. Please enter 's' for send or 'r' for receive.");
  }
}

Future<void> runSend() async {
  var process = await Process.start('dart', ['bin/send.dart'], mode: ProcessStartMode.inheritStdio);
  await process.exitCode;
}

Future<void> runReceive() async {
  var process = await Process.start('dart', ['bin/receive.dart'], mode: ProcessStartMode.inheritStdio);
  await process.exitCode;
}
