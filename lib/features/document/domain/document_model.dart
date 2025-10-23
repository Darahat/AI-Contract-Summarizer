/// Risk level enumeration
enum RiskLevel {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }
}

/// Risky clause model
class RiskyClause {
  final String id;
  final String clauseText;
  final String clauseType;
  final RiskLevel riskLevel;
  final String explanation;
  final String? recommendation;

  const RiskyClause({
    required this.id,
    required this.clauseText,
    required this.clauseType,
    required this.riskLevel,
    required this.explanation,
    this.recommendation,
  });

  factory RiskyClause.fromJson(Map<String, dynamic> json) {
    return RiskyClause(
      id: json['id'] as String,
      clauseText: json['clauseText'] as String,
      clauseType: json['clauseType'] as String,
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == json['riskLevel'],
        orElse: () => RiskLevel.medium,
      ),
      explanation: json['explanation'] as String,
      recommendation: json['recommendation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clauseText': clauseText,
      'clauseType': clauseType,
      'riskLevel': riskLevel.name,
      'explanation': explanation,
      'recommendation': recommendation,
    };
  }
}

/// Document model representing a contract document
class DocumentModel {
  final String id;
  final String userId;
  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;
  final String? summary;
  final List<String>? bulletPoints;
  final List<RiskyClause>? riskyClaus;
  final Map<String, String>? clauseExplanations;
  final bool isAnalyzed;
  final bool isEncrypted;

  const DocumentModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    this.summary,
    this.bulletPoints,
    this.riskyClaus,
    this.clauseExplanations,
    this.isAnalyzed = false,
    this.isEncrypted = false,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      summary: json['summary'] as String?,
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      riskyClaus: (json['riskyClauses'] as List<dynamic>?)
          ?.map((e) => RiskyClause.fromJson(e as Map<String, dynamic>))
          .toList(),
      clauseExplanations: (json['clauseExplanations'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
      isAnalyzed: json['isAnalyzed'] as bool? ?? false,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toIso8601String(),
      'summary': summary,
      'bulletPoints': bulletPoints,
      'riskyClauses': riskyClaus?.map((e) => e.toJson()).toList(),
      'clauseExplanations': clauseExplanations,
      'isAnalyzed': isAnalyzed,
      'isEncrypted': isEncrypted,
    };
  }

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? fileName,
    String? filePath,
    String? fileType,
    int? fileSize,
    DateTime? uploadedAt,
    String? summary,
    List<String>? bulletPoints,
    List<RiskyClause>? riskyClauses,
    Map<String, String>? clauseExplanations,
    bool? isAnalyzed,
    bool? isEncrypted,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      summary: summary ?? this.summary,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      riskyClaus: riskyClauses ?? riskyClaus,
      clauseExplanations: clauseExplanations ?? this.clauseExplanations,
      isAnalyzed: isAnalyzed ?? this.isAnalyzed,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }
}
