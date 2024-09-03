import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

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
    {
      "sender": "bot",
      "message":
          "My purpose is to help you upload and save a summary of the most important parts of your life. Every human has a special mix of likes and favorites - your personal interest graph is as unique as your fingerprint - your story deserves to be saved and shared! Uploading part of your mind will have a number of benefits."
    },
    {
      "sender": "bot",
      "message":
          "With my help, you will be able to learn new insights about yourself. I will be able to provide recommendations that are curated to your unique tastes. I will create beautiful graphics that describe your life and favorites. And I will be a permanent way to save and store what is important to you."
    },
    {"sender": "bot", "message": "<SELECTOR />"}
  ];
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  final List<String> categories = [
    'Lifestyle',
    'Career/School',
    'Sports',
    'Hobbies',
    'Music',
    'Movies',
    'TV',
    'Art',
    'Books',
    'Theatre',
    'Travel',
    'Fashion',
    'Nature',
    'Food',
    'Cars',
    'Technology',
    'Pets',
    'Fitness/Wellness',
    'Gaming'
  ];
  Set<String> selectedItems = {};

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
      var response = await http.post(
        Uri.parse('${widget.apiUrl}/api/question'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': 'Bilal Rana',
          'answer': answer,
          'id': 'ABC456',
          'topics': selectedItems.toList(),
        }),
      );

      print(response.statusCode);

      print(response.body);

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
    if (message['message'] == '<SELECTOR />') {
      return _buildSelector();
    }

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

  Widget _buildSelector() {
    double maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color(0xFFFF5757),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  )),
              child: const Text(
                "Please select a list of preferences suitable for you!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Column(
          children: categories.asMap().entries.map((entry) {
            int idx = entry.key;
            String category = entry.value;

            return Container(
                child: InkWell(
              onTap: () {
                setState(() {
                  if (!selectedItems.contains(category)) {
                    if (selectedItems.length < 5) {
                      selectedItems.add(category);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('You can select only up to 5 categories'),
                        ),
                      );
                    }
                  } else {
                    selectedItems.remove(category);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5757),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${idx + 1}. $category',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Checkbox(
                      value: selectedItems.contains(category),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked != null && isChecked) {
                            if (selectedItems.length < 5) {
                              selectedItems.add(category);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'You can select only up to 5 categories'),
                                ),
                              );
                            }
                          } else {
                            selectedItems.remove(category);
                          }
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: const Color.fromARGB(255, 139, 39, 39),
                    ),
                  ],
                ),
              ),
            ));
          }).toList(),
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
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 57, 56, 56),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF232323),
    );
  }
}
