# AI Service Integration Guide

This document explains how to integrate AI services into the AI Contract Summarizer app.

## Overview

The app uses AI services to:
1. Summarize contracts into bullet points
2. Detect risky clauses
3. Explain clauses in plain English
4. Suggest safer alternatives

## Supported AI Providers

### 1. OpenAI (Recommended)

**Setup:**
```dart
// In lib/features/document/data/ai_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  final String _apiKey;
  final String _baseUrl = 'https://api.openai.com/v1';

  AIService(this._apiKey);

  Future<Map<String, dynamic>> summarizeContract(String text) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a legal expert who analyzes contracts.',
          },
          {
            'role': 'user',
            'content': 'Summarize this contract in bullet points: $text',
          },
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _parseResponse(data);
    } else {
      throw Exception('Failed to summarize contract');
    }
  }
}
```

**Environment Setup:**
```bash
# Create .env file
OPENAI_API_KEY=sk-your-api-key-here
```

### 2. Google Generative AI (Gemini)

**Setup:**
```dart
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  late GenerativeModel _model;

  AIService(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<Map<String, dynamic>> summarizeContract(String text) async {
    final prompt = '''
    Analyze this contract and provide:
    1. A brief summary
    2. Key points as bullet points
    3. Any risky clauses
    
    Contract: $text
    ''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    
    return _parseResponse(response.text);
  }
}
```

### 3. Hugging Face

**Setup:**
```dart
import 'package:http/http.dart' as http;

class AIService {
  final String _apiKey;
  final String _baseUrl = 'https://api-inference.huggingface.co/models';

  Future<Map<String, dynamic>> summarizeContract(String text) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/facebook/bart-large-cnn'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': text,
        'parameters': {
          'max_length': 500,
          'min_length': 100,
        },
      }),
    );

    // Process response
    return _parseResponse(jsonDecode(response.body));
  }
}
```

## Prompt Engineering

### Contract Summarization Prompt
```
You are a legal expert analyzing a contract. 
Please provide:
1. A concise 2-3 sentence summary
2. 5-7 key bullet points covering:
   - Parties involved
   - Service/product being provided
   - Payment terms
   - Duration
   - Termination conditions
   - Key obligations

Contract text:
{contract_text}
```

### Risk Detection Prompt
```
Analyze this contract clause and identify any risks.
For each risky element, provide:
1. The specific clause text
2. Type of risk (payment, liability, termination, etc.)
3. Risk level (low, medium, high)
4. Plain English explanation of the risk
5. Recommended safer alternative

Clause:
{clause_text}
```

### Clause Explanation Prompt
```
Explain this legal clause in plain English that a non-lawyer can understand.
Use simple terms and provide real-world examples if helpful.

Clause:
{clause_text}
```

## Response Parsing

Example response parser:
```dart
Map<String, dynamic> _parseResponse(dynamic aiResponse) {
  // Parse AI response into structured format
  final lines = aiResponse.toString().split('\n');
  
  String? summary;
  List<String> bulletPoints = [];
  
  bool inBulletSection = false;
  
  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) continue;
    
    if (!inBulletSection && summary == null) {
      summary = line;
    } else if (line.startsWith('•') || 
               line.startsWith('-') || 
               line.startsWith('*')) {
      bulletPoints.add(line.substring(1).trim());
      inBulletSection = true;
    }
  }
  
  return {
    'summary': summary ?? 'Summary not available',
    'bulletPoints': bulletPoints,
  };
}
```

## Error Handling

```dart
Future<Map<String, dynamic>> summarizeContract(String text) async {
  try {
    // API call
    final response = await _makeApiCall(text);
    return _parseResponse(response);
  } on SocketException {
    throw ServerFailure('No internet connection');
  } on HttpException {
    throw ServerFailure('API request failed');
  } on FormatException {
    throw ServerFailure('Invalid response format');
  } catch (e) {
    throw ServerFailure('Unexpected error: $e');
  }
}
```

## Rate Limiting

Implement rate limiting to avoid API quota issues:

```dart
class AIService {
  final RateLimiter _rateLimiter = RateLimiter(
    maxRequests: 10,
    duration: const Duration(minutes: 1),
  );

  Future<Map<String, dynamic>> summarizeContract(String text) async {
    await _rateLimiter.acquire();
    
    // Make API call
    return _makeApiCall(text);
  }
}
```

## Cost Optimization

1. **Caching**: Cache AI responses for identical inputs
2. **Text Chunking**: Split large documents
3. **Model Selection**: Use cheaper models for simple tasks
4. **Batch Processing**: Process multiple clauses together

Example caching:
```dart
final _cache = <String, Map<String, dynamic>>{};

Future<Map<String, dynamic>> summarizeContract(String text) async {
  final hash = _hashText(text);
  
  if (_cache.containsKey(hash)) {
    return _cache[hash]!;
  }
  
  final result = await _makeApiCall(text);
  _cache[hash] = result;
  
  return result;
}
```

## Testing

Mock AI service for testing:

```dart
class MockAIService implements AIService {
  @override
  Future<Map<String, dynamic>> summarizeContract(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return {
      'summary': 'Mock contract summary',
      'bulletPoints': [
        'Mock point 1',
        'Mock point 2',
        'Mock point 3',
      ],
    };
  }
}
```

## Best Practices

1. **API Key Security**
   - Never commit API keys
   - Use environment variables
   - Store in secure storage on device

2. **User Experience**
   - Show loading indicators
   - Handle errors gracefully
   - Provide offline functionality

3. **Privacy**
   - Encrypt data before sending to API
   - Allow users to opt-out of AI features
   - Don't log sensitive contract data

4. **Monitoring**
   - Track API usage
   - Log errors
   - Monitor response times

## Configuration

Update `lib/services/api_client.dart` with your API settings:

```dart
class APIConfig {
  static const String openAIKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  
  static const String baseUrl = 'https://api.openai.com/v1';
  static const Duration timeout = Duration(seconds: 30);
}
```

## Support

For issues or questions:
- Check [OpenAI Documentation](https://platform.openai.com/docs)
- Check [Google AI Documentation](https://ai.google.dev/docs)
- Open an issue in the repository
