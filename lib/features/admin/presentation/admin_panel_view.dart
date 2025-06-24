import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class AdminPanelView extends ConsumerStatefulWidget {
  const AdminPanelView({super.key});

  @override
  ConsumerState<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends ConsumerState<AdminPanelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.event), text: 'Events'),
            Tab(icon: Icon(Icons.person), text: 'Figures'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.report), text: 'Reports'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DashboardTab(),
          _EventsTab(),
          _FiguresTab(),
          _UsersTab(),
          _ReportsTab(),
          _SettingsTab(),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _DashboardCard(
                  title: 'Total Events',
                  value: '1,234',
                  icon: Icons.event,
                  color: AppColors.primary,
                ),
                _DashboardCard(
                  title: 'Historical Figures',
                  value: '856',
                  icon: Icons.person,
                  color: AppColors.secondary,
                ),
                _DashboardCard(
                  title: 'Active Users',
                  value: '12,456',
                  icon: Icons.people,
                  color: AppColors.info,
                ),
                _DashboardCard(
                  title: 'Pending Reviews',
                  value: '23',
                  icon: Icons.pending_actions,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.h2.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  const _EventsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Events Management',
                style: AppTextStyles.h2,
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/create-event'),
                icon: const Icon(Icons.add),
                label: const Text('Create Event'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Historical Event ${index + 1}'),
                    subtitle: Text(
                        'Region: Ancient Rome • Year: ${100 + index * 50} BCE'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          context.push('/create-event');
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, 'event');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiguresTab extends StatelessWidget {
  const _FiguresTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historical Figures Management',
                style: AppTextStyles.h2,
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/create-figure'),
                icon: const Icon(Icons.add),
                label: const Text('Create Figure'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                final figures = [
                  'Julius Caesar',
                  'Cleopatra VII',
                  'Alexander the Great',
                  'Hannibal',
                  'Augustus',
                  'Marcus Aurelius',
                  'Spartacus',
                  'Cicero',
                ];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(figures[index]),
                    subtitle: Text(
                        'Period: Ancient Rome • Born: ${100 + index * 20} BCE'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          context.push('/create-figure');
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, 'figure');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Management',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                final userTypes = ['Admin', 'Moderator', 'User', 'Contributor'];
                final userType = userTypes[index % userTypes.length];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getUserTypeColor(userType),
                      child: Text(
                        'U${index + 1}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text('User ${index + 1}'),
                    subtitle: Text(
                        'Role: $userType • Joined: Jan ${index + 1}, 2024'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'promote',
                          child: Row(
                            children: [
                              Icon(Icons.upgrade),
                              SizedBox(width: 8),
                              Text('Promote'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'suspend',
                          child: Row(
                            children: [
                              Icon(Icons.block, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('Suspend',
                                  style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        _showUserActionDialog(context, value.toString());
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getUserTypeColor(String userType) {
    switch (userType) {
      case 'Admin':
        return Colors.red;
      case 'Moderator':
        return Colors.orange;
      case 'Contributor':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reports & Analytics',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 48,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'User Growth',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+12.5% this month',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Page Views',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '145,678 this week',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Activity',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                final activities = [
                  'New event created: "Battle of Actium"',
                  'User John Doe created a new figure',
                  'Event "Fall of Rome" was updated',
                  'New user registration: jane.smith@email.com',
                  'Figure "Augustus" received new image upload',
                ];
                final activity = activities[index % activities.length];
                return ListTile(
                  leading: const Icon(Icons.history, color: AppColors.grey400),
                  title: Text(activity),
                  subtitle:
                      Text('${index + 1} hour${index == 0 ? '' : 's'} ago'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security Settings'),
                  subtitle: const Text('Manage authentication and permissions'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSettingsDialog(context, 'Security Settings');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Backup & Recovery'),
                  subtitle: const Text('Configure data backup settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSettingsDialog(context, 'Backup & Recovery');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('API Configuration'),
                  subtitle: const Text('Manage external API settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSettingsDialog(context, 'API Configuration');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Database Management'),
                  subtitle: const Text(
                      'View database status and perform maintenance'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSettingsDialog(context, 'Database Management');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification Settings'),
                  subtitle: const Text('Configure system notifications'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSettingsDialog(context, 'Notification Settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, String itemType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $itemType'),
        content: Text(
            'Are you sure you want to delete this $itemType? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$itemType deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void _showUserActionDialog(BuildContext context, String action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$action User'),
        content: Text('Are you sure you want to $action this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User $action successfully')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

void _showSettingsDialog(BuildContext context, String settingType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(settingType),
        content: Text('$settingType configuration panel would open here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
