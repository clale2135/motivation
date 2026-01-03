import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static String? getOpenAIApiKey() {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        return null;
      }
      return apiKey;
    } catch (e) {
      print('Error getting API key: $e');
      return null;
    }
  }
}

