# drivestr-cli
A decentralized cloud storage terminal application based on Nostr, featuring end-to-end encryption and using relays for data storage and transmitting.

## Installation

1. **Install Dart SDK**

   - **macOS**
     ```bash
     brew tap dart-lang/dart
     brew install dart
     dart --version
     ```
   - **Windows**
     - Download Dart SDK from [Dart SDK Download](https://dart.dev/get-dart), run the installer, then verify installation with:
       ```cmd
       dart --version
       ```
   - **Linux**
     ```bash
     sudo apt update
     sudo apt install apt-transport-https
     sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
     sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
     sudo apt update
     sudo apt install dart
     dart --version
     ```

2. **Clone the Repository**
   ```git clone https://github.com/drivestr/drivestr-cli.git```

3. **Start using Drivestr**

```cd drivestr-cli
dart pub get
dart run lib/main.dart```
