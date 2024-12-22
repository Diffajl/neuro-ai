import 'package:flutter/material.dart';
import 'package:groq/groq.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SendDataPage(),
    );
  }
}

class SendDataPage extends StatefulWidget {
  const SendDataPage({super.key});

  @override
  _SendDataPageState createState() => _SendDataPageState();
}

class _SendDataPageState extends State<SendDataPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;

  Future<void> sendData(String prompt) async {
    final groq = Groq(
      apiKey: "your API key",
    );
    groq.startChat();
    try {
      GroqResponse response = await groq.sendMessage(prompt);
      setState(() {
        _response = response.choices.first.message.content;
      });
    } on GroqException catch (error) {
      print(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neuro AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter prompt'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final prompt = _controller.text;
                sendData(prompt);
              },
              child: const Text('Send Prompt'),
            ),
            const SizedBox(height: 20),
            if (_response != null)
              Text(
                _response!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
