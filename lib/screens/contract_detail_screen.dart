import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/contract.dart';
import '../utils/theme.dart';
import '../providers/contract_provider.dart';

class ContractDetailScreen extends ConsumerWidget {
  final Contract contract;

  const ContractDetailScreen({super.key, required this.contract});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context, ref);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildStatusCard(context),
            if (contract.summary != null) _buildSummaryCard(context),
            if (contract.riskyClause.isNotEmpty) _buildRiskyClauseCard(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.fileName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Uploaded ${DateFormat('MMM dd, yyyy').format(contract.uploadDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final statusInfo = _getStatusInfo();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              statusInfo['icon'],
              color: statusInfo['color'],
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    statusInfo['text'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: statusInfo['color'],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo() {
    switch (contract.status) {
      case ContractStatus.completed:
        return {
          'icon': Icons.check_circle,
          'color': AppTheme.accentColor,
          'text': 'Analysis Complete',
        };
      case ContractStatus.processing:
        return {
          'icon': Icons.hourglass_empty,
          'color': AppTheme.warningColor,
          'text': 'Processing...',
        };
      case ContractStatus.error:
        return {
          'icon': Icons.error,
          'color': AppTheme.errorColor,
          'text': 'Analysis Failed',
        };
      default:
        return {
          'icon': Icons.pending,
          'color': Colors.grey,
          'text': 'Pending',
        };
    }
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.summarize,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              contract.summary!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskyClauseCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: AppTheme.warningColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Risky Clauses (${contract.riskyClause.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...contract.riskyClause.map((clause) => _buildRiskClauseItem(context, clause)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskClauseItem(BuildContext context, RiskClause clause) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.getRiskColor(clause.riskLevel.toString().split('.').last),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(
                  clause.type.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppTheme.getRiskColor(clause.riskLevel.toString().split('.').last),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  clause.riskLevel.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Clause:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Text(
            clause.clauseText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Risk:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Text(
            clause.explanation,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Recommendation:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  clause.recommendation,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contract'),
        content: const Text('Are you sure you want to delete this contract? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(contractsProvider.notifier).deleteContract(contract.id);
                if (context.mounted) {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close detail screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contract deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
