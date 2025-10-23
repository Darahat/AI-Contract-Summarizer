import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../models/user_subscription.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      body: subscriptionAsync.when(
        data: (subscription) => _buildContent(context, ref, subscription),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, UserSubscription subscription) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Choose Your Plan',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Get quick, affordable legal clarity for your contracts',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildPlanCard(
            context,
            ref,
            isCurrentPlan: subscription.plan == SubscriptionPlan.free,
            title: 'FREE',
            price: '\$0',
            period: 'forever',
            features: [
              '2 documents per month',
              'AI-powered summaries',
              'Risk detection',
              'AES encryption',
              'Document history',
            ],
            onTap: subscription.plan == SubscriptionPlan.pro
                ? () => _showDowngradeDialog(context, ref)
                : null,
            buttonText: subscription.plan == SubscriptionPlan.free ? 'Current Plan' : 'Downgrade',
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            ref,
            isCurrentPlan: subscription.plan == SubscriptionPlan.pro,
            title: 'PRO',
            price: '\$12',
            period: 'per month',
            features: [
              'Unlimited documents',
              'AI-powered summaries',
              'Advanced risk detection',
              'AES encryption',
              'Priority support',
              'Export reports (PDF)',
              'Custom clause explanations',
            ],
            isPremium: true,
            onTap: subscription.plan == SubscriptionPlan.free
                ? () => _showUpgradeDialog(context, ref)
                : null,
            buttonText: subscription.plan == SubscriptionPlan.pro ? 'Current Plan' : 'Upgrade to Pro',
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Target Audience',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ClauseWise is designed for freelancers and SMEs in developed markets seeking quick, affordable legal clarity without expensive lawyer consultations.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref, {
    required bool isCurrentPlan,
    required String title,
    required String price,
    required String period,
    required List<String> features,
    bool isPremium = false,
    VoidCallback? onTap,
    required String buttonText,
  }) {
    return Card(
      elevation: isPremium ? 8 : 2,
      color: isPremium ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isPremium)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⭐ RECOMMENDED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (isPremium) const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isPremium ? Theme.of(context).colorScheme.onPrimaryContainer : null,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isPremium ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: isPremium ? Theme.of(context).colorScheme.primary : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: isPremium ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isCurrentPlan ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium ? Theme.of(context).colorScheme.primary : null,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: const Text(
          'This is a demo version. In a production app, this would integrate with payment providers like Stripe or Apple/Google Pay.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(subscriptionProvider.notifier).upgradeToPro();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully upgraded to Pro!'),
                      backgroundColor: Colors.green,
                    ),
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
            child: const Text('Upgrade (Demo)'),
          ),
        ],
      ),
    );
  }

  void _showDowngradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Downgrade to Free'),
        content: const Text(
          'Are you sure you want to downgrade to the free plan? You\'ll be limited to 2 documents per month.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(subscriptionProvider.notifier).cancelSubscription();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downgraded to free plan')),
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
            child: const Text('Downgrade'),
          ),
        ],
      ),
    );
  }
}
