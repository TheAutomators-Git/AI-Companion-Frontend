import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:provider/provider.dart'; // Import provider
import '../providers/category_selection_provider.dart'; // Import the provider

class HomePage extends StatefulWidget {
  final String apiUrl;
  const HomePage({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> messages = [
    {
      "sender": "bot",
      "message": "Hello and welcome to Favlist, your Personalized AI Companion."
    },
  ];
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _saveConversation() async {
    try {
      var response = await http.post(
        Uri.parse('${widget.apiUrl}/api/save'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': 'User',
          'id': 'AB123',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save conversation');
      }
    } catch (e) {
      print('Error saving conversation: $e');
    }
  }

  void _saveImage() async {
    try {
      var response = await http.post(
        Uri.parse('${widget.apiUrl}/api/generate'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body:
            jsonEncode(<String, dynamic>{'name': 'Bilal Rana', 'id': 'ABC456'}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Uint8List bytes = base64Decode(data['image']);
        setState(() {
          messages.add({"sender": "bot", "image": bytes});
        });
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Something Went Wrong :("});
      });
    }
  }

  void _pingAPI(String answer) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Access the provider's selected categories
      final selectedItems =
          Provider.of<CategorySelectionProvider>(context, listen: false)
              .getSelectedCategoryNames([
    'Lifestyle', 'Career/School', 'Sports', 'Hobbies', 'Music', 'Movies',
    'TV', 'Art', 'Books', 'Theatre', 'Travel',
    'Fashion', 'Nature', 'Food', 'Cars', 'Technology',
    'Pets', 'Fitness/Wellness', 'Gaming'
  ]);
      print(answer);
      print(selectedItems.toString());

      var response = await http.post(
        Uri.parse('${widget.apiUrl}/api/question'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': 'Test User',
          'answer': answer,
          'id': 'ABC456',
          'topics': selectedItems,
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['completed'] == true) {
          setState(() {
            messages.add({
              "sender": "bot",
              "message":
                  'Please wait while we generate your personalized image!'
            });
          });
          _saveImage();
        } else {
          setState(() {
            messages.add({"sender": "bot", "message": data['question']});
          });
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        _saveConversation();
        throw Exception('Failed to load response');
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Something Went Wrong :("});
        _isLoading = false;
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
      _pingAPI(text);
    }
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        _saveConversation();
      },
      child: const Text('Save Conversation'),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isLast) {
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
              child: message.containsKey('image')
                  ? Image.memory(
                      message['image'],
                      fit: BoxFit.cover,
                    )
                  : Text(
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
        padding: const EdgeInsets.fromLTRB(20,20,20,30),
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isLast = index == messages.length - 1;
                  return _buildMessage(messages[index], isLast);
                },
              ),
            ),
            if (messages.isEmpty)
              const Center(
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 10),
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
                  ),
                ],
              ),),
          ],
        ),
      ),
    );
  }
}
