import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class nextWordPrediction extends StatefulWidget {
  const nextWordPrediction({super.key});

  @override
  State<nextWordPrediction> createState() => _SentimentanalysisState();
}

class _SentimentanalysisState extends State<nextWordPrediction> {
  TextEditingController sentimentText = TextEditingController();
  String result = "";
  bool isLoading = false;
  String errorMessage = "";

  Future<void> getAnalysisAnswer() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String text = sentimentText.text;
    // Use your current ngrok URL
    final String baseUrl = "https://f2e7-34-106-73-104.ngrok-free.app";

    try {
      // URL encode the text parameter
      final encodedText = Uri.encodeComponent(text);
      final Uri uri = Uri.parse("$baseUrl/predict/?text=$encodedText");

      final response = await http.get(uri, headers: {
        'ngrok-skip-browser-warning': 'true' // Bypass ngrok warning
      });

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          setState(() {
            result = data['predicted_word'];
            isLoading = false;
          });
        } catch (parseError) {
          setState(() {
            errorMessage = "Failed to parse response: $parseError";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030333),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next Word Prediction",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: TextField(
                  controller: sentimentText,
                  maxLines: null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      hintText: "Paste your  text",
                      hintStyle: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                    onPressed: isLoading ? null : getAnalysisAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: Colors.green.withOpacity(0.6),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Predict Next Word",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          )),
              ),
              SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (result.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getResultColor(result),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Next Predict Word: ${result.toUpperCase()}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Color getResultColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.green;
      case 'neutral':
        return Colors.green;
      default:
        return Colors.green;
    }
  }
}
