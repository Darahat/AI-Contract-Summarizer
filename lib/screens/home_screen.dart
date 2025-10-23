import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contract_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/contract_card.dart';
import 'upload_screen.dart';
import 'settings_screen.dart';
import 'subscription_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final contractsAsync = ref.watch(contractsProvider);
    final subscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ClauseWise'),
        actions: [
          subscriptionAsync.when(
            data: (subscription) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Chip(
                  label: Text(
                    subscription.plan == SubscriptionPlan.pro ? 'PRO' : 'FREE',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: subscription.plan == SubscriptionPlan.pro
                      ? Colors.amber
                      : Colors.grey[300],
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeContent(contractsAsync, subscriptionAsync) : const SubscriptionScreen(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadScreen()),
                );
                if (result == true) {
                  ref.read(contractsProvider.notifier).loadContracts();
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Contract'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium),
            label: 'Subscription',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(AsyncValue contractsAsync, AsyncValue subscriptionAsync) {
    return contractsAsync.when(
      data: (contracts) {
        if (contracts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No contracts yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                subscriptionAsync.when(
                  data: (subscription) {
                    return Text(
                      'You can upload ${subscription.maxDocuments - subscription.documentsUsedThisMonth} more documents this month',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UploadScreen()),
                    );
                    if (result == true) {
                      ref.read(contractsProvider.notifier).loadContracts();
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Your First Contract'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            subscriptionAsync.when(
              data: (subscription) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_chart,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Documents this month',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${subscription.documentsUsedThisMonth} / ${subscription.maxDocuments}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (subscription.plan == SubscriptionPlan.free)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: const Text('Upgrade'),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(contractsProvider.notifier).loadContracts();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    return ContractCard(contract: contracts[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(contractsProvider.notifier).loadContracts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
