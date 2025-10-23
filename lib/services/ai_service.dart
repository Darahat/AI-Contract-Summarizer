import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contract.dart';

class AIService {
  final String apiKey;
  final AIProvider provider;
  
  AIService({
    required this.apiKey,
    this.provider = AIProvider.openai,
  });

  Future<String> generateSummary(String contractText) async {
    try {
      final prompt = '''
Analyze this contract and provide a concise summary covering:
1. Main parties involved
2. Purpose of the agreement
3. Key obligations
4. Payment terms
5. Duration and termination
6. Important deadlines

Contract text:
$contractText
''';

      final response = await _sendRequest(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }

  Future<List<RiskClause>> detectRiskyClause(String contractText) async {
    try {
      final prompt = '''
Analyze this contract and identify risky clauses in these categories:
1. Payment terms (unclear payment schedules, unfavorable terms)
2. Liability clauses (unlimited liability, indemnification issues)
3. Intellectual Property rights (IP ownership, usage rights)

For each risky clause found, provide:
- Type (payment/liability/intellectualProperty)
- The actual clause text
- Simple explanation of the risk
- Risk level (low/medium/high/critical)
- Recommendation for action

Format your response as JSON array:
[
  {
    "type": "payment",
    "clauseText": "...",
    "explanation": "...",
    "riskLevel": "high",
    "recommendation": "..."
  }
]

Contract text:
$contractText
''';

      final response = await _sendRequest(prompt);
      return _parseRiskClause(response);
    } catch (e) {
      throw Exception('Failed to detect risky clauses: $e');
    }
  }

  Future<String> explainClause(String clauseText) async {
    try {
      final prompt = '''
Explain this contract clause in simple terms that a non-lawyer can understand:

Clause: $clauseText

Provide:
1. What it means in plain English
2. Why it matters
3. Potential implications
''';

      final response = await _sendRequest(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to explain clause: $e');
    }
  }

  Future<String> _sendRequest(String prompt) async {
    switch (provider) {
      case AIProvider.openai:
        return await _sendOpenAIRequest(prompt);
      case AIProvider.mistral:
        return await _sendMistralRequest(prompt);
    }
  }

  Future<String> _sendOpenAIRequest(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a legal assistant helping freelancers and small businesses understand contracts.'
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.3,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _sendMistralRequest(String prompt) async {
    final url = Uri.parse('https://api.mistral.ai/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'mistral-large-latest',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a legal assistant helping freelancers and small businesses understand contracts.'
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.3,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Mistral API error: ${response.statusCode} - ${response.body}');
    }
  }

  List<RiskClause> _parseRiskClause(String jsonResponse) {
    try {
      // Try to extract JSON from the response
      final jsonStart = jsonResponse.indexOf('[');
      final jsonEnd = jsonResponse.lastIndexOf(']') + 1;
      
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonStr = jsonResponse.substring(jsonStart, jsonEnd);
        final List<dynamic> data = jsonDecode(jsonStr);
        
        return data.map((item) {
          return RiskClause(
            type: item['type'] ?? 'other',
            clauseText: item['clauseText'] ?? '',
            explanation: item['explanation'] ?? '',
            riskLevel: _parseRiskLevel(item['riskLevel']),
            recommendation: item['recommendation'] ?? '',
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      // If parsing fails, return empty list
      return [];
    }
  }

  RiskLevel _parseRiskLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
        return RiskLevel.medium;
      case 'high':
        return RiskLevel.high;
      case 'critical':
        return RiskLevel.critical;
      default:
        return RiskLevel.medium;
    }
  }
}

enum AIProvider {
  openai,
  mistral,
}
