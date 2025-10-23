import 'package:hive/hive.dart';

part 'contract.g.dart';

@HiveType(typeId: 0)
class Contract {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fileName;
  
  @HiveField(2)
  final String filePath;
  
  @HiveField(3)
  final DateTime uploadDate;
  
  @HiveField(4)
  final String? summary;
  
  @HiveField(5)
  final List<RiskClause> riskyClause;
  
  @HiveField(6)
  final String encryptedContent;
  
  @HiveField(7)
  final ContractStatus status;

  Contract({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.uploadDate,
    this.summary,
    this.riskyClause = const [],
    required this.encryptedContent,
    this.status = ContractStatus.pending,
  });

  Contract copyWith({
    String? id,
    String? fileName,
    String? filePath,
    DateTime? uploadDate,
    String? summary,
    List<RiskClause>? riskyClause,
    String? encryptedContent,
    ContractStatus? status,
  }) {
    return Contract(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      uploadDate: uploadDate ?? this.uploadDate,
      summary: summary ?? this.summary,
      riskyClause: riskyClause ?? this.riskyClause,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'filePath': filePath,
      'uploadDate': uploadDate.toIso8601String(),
      'summary': summary,
      'riskyClause': riskyClause.map((e) => e.toJson()).toList(),
      'encryptedContent': encryptedContent,
      'status': status.toString(),
    };
  }

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      uploadDate: DateTime.parse(json['uploadDate']),
      summary: json['summary'],
      riskyClause: (json['riskyClause'] as List?)
          ?.map((e) => RiskClause.fromJson(e))
          .toList() ?? [],
      encryptedContent: json['encryptedContent'],
      status: ContractStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ContractStatus.pending,
      ),
    );
  }
}

@HiveType(typeId: 1)
enum ContractStatus {
  @HiveField(0)
  pending,
  
  @HiveField(1)
  processing,
  
  @HiveField(2)
  completed,
  
  @HiveField(3)
  error,
}

@HiveType(typeId: 2)
class RiskClause {
  @HiveField(0)
  final String type;
  
  @HiveField(1)
  final String clauseText;
  
  @HiveField(2)
  final String explanation;
  
  @HiveField(3)
  final RiskLevel riskLevel;
  
  @HiveField(4)
  final String recommendation;

  RiskClause({
    required this.type,
    required this.clauseText,
    required this.explanation,
    required this.riskLevel,
    required this.recommendation,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'clauseText': clauseText,
      'explanation': explanation,
      'riskLevel': riskLevel.toString(),
      'recommendation': recommendation,
    };
  }

  factory RiskClause.fromJson(Map<String, dynamic> json) {
    return RiskClause(
      type: json['type'],
      clauseText: json['clauseText'],
      explanation: json['explanation'],
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.toString() == json['riskLevel'],
        orElse: () => RiskLevel.medium,
      ),
      recommendation: json['recommendation'],
    );
  }
}

@HiveType(typeId: 3)
enum RiskLevel {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high,
  
  @HiveField(3)
  critical,
}

@HiveType(typeId: 4)
enum RiskType {
  @HiveField(0)
  payment,
  
  @HiveField(1)
  liability,
  
  @HiveField(2)
  intellectualProperty,
  
  @HiveField(3)
  termination,
  
  @HiveField(4)
  confidentiality,
  
  @HiveField(5)
  other,
}
