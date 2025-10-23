import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contract_provider.dart';
import '../providers/subscription_provider.dart';
import '../services/contract_storage_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final savedApiKey = ref.read(apiKeyProvider);
    if (savedApiKey != null) {
      _apiKeyController.text = savedApiKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection(
            context,
            title: 'API Configuration',
            children: [
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('OpenAI API Key'),
                subtitle: Text(
                  _apiKeyController.text.isEmpty 
                    ? 'Not configured' 
                    : '••••••••${_apiKeyController.text.substring(_apiKeyController.text.length - 4)}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => _showApiKeyDialog(context),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Subscription',
            children: [
              subscriptionAsync.when(
                data: (subscription) => ListTile(
                  leading: const Icon(Icons.workspace_premium),
                  title: Text('${subscription.plan.toString().split('.').last.toUpperCase()} Plan'),
                  subtitle: Text(
                    subscription.plan == SubscriptionPlan.pro
                        ? 'Unlimited documents'
                        : '${subscription.documentsUsedThisMonth} / ${subscription.maxDocuments} documents used this month',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate back and switch to subscription tab
                    Navigator.of(context).pop();
                    // This would require communicating with HomeScreen
                  },
                ),
                loading: () => const ListTile(
                  leading: Icon(Icons.workspace_premium),
                  title: Text('Loading...'),
                ),
                error: (_, __) => const ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Error loading subscription'),
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Data & Privacy',
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Encryption'),
                subtitle: const Text('AES encryption enabled'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Clear All Data'),
                subtitle: const Text('Delete all contracts and settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showClearDataDialog(context),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('About ClauseWise'),
                subtitle: const Text('Your AI Legal Companion'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: _apiKeyController.text);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OpenAI API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your API key is stored locally and never shared. Get your key at platform.openai.com',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _apiKeyController.text = controller.text;
              });
              ref.read(apiKeyProvider.notifier).state = controller.text;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('API key saved')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your contracts, settings, and subscription information. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final storage = ContractStorageService();
                await storage.clearAll();
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data cleared')),
                  );
                  
                  // Reload data
                  ref.read(contractsProvider.notifier).loadContracts();
                  ref.read(subscriptionProvider.notifier).loadSubscription();
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
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ClauseWise'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ClauseWise - Your AI Legal Companion',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Designed for freelancers and SMEs in developed markets, ClauseWise provides quick, affordable legal clarity for your contracts.',
              ),
              SizedBox(height: 12),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• AI-powered contract summaries'),
              Text('• Risk detection (payment, liability, IP)'),
              Text('• Simple term explanations'),
              Text('• AES encryption for security'),
              Text('• Document history'),
              SizedBox(height: 12),
              Text(
                'Built with Flutter + Riverpod',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              Text(
                'Integrates OpenAI/Mistral for AI analysis',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
