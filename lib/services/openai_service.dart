import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;
  static const String apiUrl = 'https://api.openai.com/v1/chat/completions';

  OpenAIService({required this.apiKey});

  Future<int?> analyzeVideoProductivity(List<String> frameBase64Images) async {
    try {
      final List<Map<String, dynamic>> content = [
        {
          'type': 'text',
          'text': '''Analyze these video frames of someone studying. Rate their productivity on a scale of 1-100 based on:
- Focus and attention (are they looking at study materials?)
- Posture and engagement (are they actively studying or distracted?)
- Environment (is it conducive to studying?)
- Activity level (are they actively working or passive?)

Return ONLY a JSON object with this exact format:
{"productivity_score": <number between 1-100>}

Do not include any other text or explanation, just the JSON.'''
        }
      ];

      // Add up to 3 frames for analysis (to stay within token limits)
      final framesToAnalyze = frameBase64Images.take(3).toList();
      for (final frame in framesToAnalyze) {
        content.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$frame',
          }
        });
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              'content': content,
            }
          ],
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentText = data['choices'][0]['message']['content'];
        
        // Extract JSON from response
        final jsonMatch = RegExp(r'\{[^}]*"productivity_score"[^}]*\}').firstMatch(contentText);
        if (jsonMatch != null) {
          final jsonData = jsonDecode(jsonMatch.group(0)!);
          return jsonData['productivity_score'] as int?;
        }
      } else {
        print('OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error analyzing video: $e');
    }
    return null;
  }
}

