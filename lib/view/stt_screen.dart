import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;



class SpeechToTextWidget extends StatefulWidget {
  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  FlutterTts _flutterTts = FlutterTts();
  String _transcribedText = '';
  bool _isRecording = false;
  stt.SpeechToText? _speech;
  TextEditingController _speechRecognition = TextEditingController();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeTTS();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (status) {
          print('Status: $status');
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech!.listen(
          onResult: (result) {
            setState(() {
              _speechRecognition.text = result.recognizedWords;
              _transcribedText = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech!.stop();
      });
    }
  }
  // Initialize Text-to-Speech
  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  // Start audio recording
  Future<void> _startRecording() async {
    await Permission.microphone.request();
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      print('Permission denied');
      return;
    }

    await _audioRecorder.startRecorder(toFile: 'audio_file.wav');
    setState(() {
      _isRecording = true;
    });
  }

  // Stop recording and transcribe the audio using Whisper API
  Future<void> _stopRecording() async {
    String? filePath = await _audioRecorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    String transcribedText = await _transcribeAudio(filePath!);
    setState(() {
      _transcribedText = transcribedText;
    });
  }

  // Transcribe audio to text using OpenAI Whisper API
  Future<String> _transcribeAudio(String filePath) async {
    String apiKey = 'your-openai-api-key'; // Replace with your OpenAI API key
    Uri url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..files.add(await http.MultipartFile.fromPath('file', filePath))
      ..fields['model'] = 'whisper-1'; // Use Whisper model for transcription

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['text'];
    } else {
      throw Exception('Failed to transcribe audio. Error: ${response.statusCode}');
    }
  }

  // Convert text to speech
  void _speakText(String text) async {
    await _flutterTts.speak(text);
  }

  // Stop speech
  void _stopSpeech() async {
    await _flutterTts.stop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech-to-Text and Text-to-Speech') ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            // Text(
            //   'Transcribed Text: $_transcribedText',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 20),
            TextFormField(
              controller: _speechRecognition,
              decoration: InputDecoration(
                labelText: 'Enter Text for TTS',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 30.0,
                    color: _isListening ? Colors.blueGrey : Colors.white,
                  ),
                  onPressed: _listen,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _transcribedText = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Container(
            //   child: TextFormField(
            //     controller: _speechRecognition,
            //     decoration: InputDecoration(
            //       labelText: 'Remarks',
            //       border: OutlineInputBorder(),
            //       suffixIcon: IconButton(
            //         icon: Icon(
            //           _isListening ? Icons.mic : Icons.mic_none,
            //           size: 30.0,
            //           color: _isListening ? Colors.blueGrey : Colors.white,
            //         ),
            //         onPressed: _listen,
            //       ),
            //     ),
            //     inputFormatters: [
            //       LengthLimitingTextInputFormatter(1),
            //     ],
            //     keyboardType: TextInputType.number,
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _speakText(_transcribedText),
              child: Text('Speak Text'),
            ),
            ElevatedButton(
              onPressed: _stopSpeech,
              child: Text('Stop Speaking'),
            ),
          ],
        ),
      ),
    );
  }
}
