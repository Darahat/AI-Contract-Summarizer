import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/contract.dart';
import '../screens/contract_detail_screen.dart';
import '../utils/theme.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;

  const ContractCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractDetailScreen(contract: contract),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contract.fileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(contract.uploadDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(contract.status),
                ],
              ),
              if (contract.riskyClause.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${contract.riskyClause.length} risky clause${contract.riskyClause.length > 1 ? 's' : ''} detected',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _getRiskLevelChips(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ContractStatus status) {
    IconData icon;
    Color color;
    String label;

    switch (status) {
      case ContractStatus.completed:
        icon = Icons.check_circle;
        color = AppTheme.accentColor;
        label = 'Done';
        break;
      case ContractStatus.processing:
        icon = Icons.hourglass_empty;
        color = AppTheme.warningColor;
        label = 'Processing';
        break;
      case ContractStatus.error:
        icon = Icons.error;
        color = AppTheme.errorColor;
        label = 'Error';
        break;
      default:
        icon = Icons.pending;
        color = Colors.grey;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getRiskLevelChips() {
    final riskCounts = <RiskLevel, int>{};
    for (var clause in contract.riskyClause) {
      riskCounts[clause.riskLevel] = (riskCounts[clause.riskLevel] ?? 0) + 1;
    }

    return riskCounts.entries.map((entry) {
      final levelStr = entry.key.toString().split('.').last;
      return Chip(
        label: Text(
          '${entry.value} ${levelStr}',
          style: const TextStyle(fontSize: 10),
        ),
        backgroundColor: AppTheme.getRiskColor(levelStr).withOpacity(0.2),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }).toList();
  }
}
