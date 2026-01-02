import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static String getOpenAIApiKey() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY not found in .env file');
    }
    return apiKey;
  }
}

