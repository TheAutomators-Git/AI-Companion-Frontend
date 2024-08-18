import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String apiUrl;

  const HomePage({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> messages = [
    {
      "sender": "bot",
      "message":
          "Hello! Welcome to AI Companion App! I am here to assist you today! Let's start by a small conversion!"
    }
  ];
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false; // This will manage the state of loading

  @override
  void initState() {
    super.initState();
    _pingAPI();
  }

  void _pingAPI() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      var response = await http.post(
        Uri.parse('${widget.apiUrl}/api/question'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': 'User',
          'answer': '',
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          messages.add({"sender": "bot", "message": data['question']});
          _isLoading = false; // Stop loading after getting response
        });
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Something Went Wrong :("});
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        messages.add({"sender": "user", "message": text});
        _controller.clear();
      });
      _pingAPI();
    }
  }

  Widget _buildMessage(Map<String, String> message, bool isLast) {
    bool isUser = message['sender'] == 'user';
    double maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFFFF5757) : const Color(0xFFFF5757),
                borderRadius: isUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
              child: Text(
                message['message']!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        if (isLast && _isLoading)
          const Column(
            children: [
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI Companion',
                  style: TextStyle(fontSize: 26, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => {Navigator.pushNamed(context, '/login')},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(
                      messages[messages.length - 1 - index], index == 0);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Type a message...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(0, 255, 255, 255),
                      ),
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendMessage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Icon(Icons.send),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
