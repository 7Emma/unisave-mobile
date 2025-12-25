import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Palette de couleurs
  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  // Notifications fictives
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Nouveau dépôt reçu',
      'description': 'Emma a contribué 50€ à la tontine "Vacances"',
      'time': 'Il y a 2 heures',
      'icon': Icons.attach_money,
      'color': gold,
      'read': false,
    },
    {
      'title': 'Tontine complétée',
      'description': 'La tontine "Fête" a atteint son objectif!',
      'time': 'Il y a 5 heures',
      'icon': Icons.celebration,
      'color': Colors.green,
      'read': false,
    },
    {
      'title': 'Invitation acceptée',
      'description': 'Marc a accepté votre invitation pour "Maison"',
      'time': 'Il y a 1 jour',
      'icon': Icons.person_add,
      'color': Colors.blue,
      'read': true,
    },
    {
      'title': 'Appel de fonds',
      'description': 'Rappel: dépôt mensuel pour "Vacances" due demain',
      'time': 'Il y a 2 jours',
      'icon': Icons.notifications_active,
      'color': Colors.orange,
      'read': true,
    },
    {
      'title': 'Nouveau membre',
      'description': 'Sophie a rejoint la tontine "Bureau"',
      'time': 'Il y a 3 jours',
      'icon': Icons.group_add,
      'color': Colors.purple,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['read']).length;

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount non lue${unreadCount > 1 ? 's' : ''}',
                style: TextStyle(
                  color: gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: darkGreen.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune notification',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vous êtes à jour!',
                    style: TextStyle(
                      color: darkGreen.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notification['read']
                        ? Colors.white
                        : gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(
                        color: notification['color'],
                        width: 4,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (notification['color'] as Color)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          notification['icon'],
                          color: notification['color'],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['title'],
                                    style: TextStyle(
                                      color: darkGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!notification['read'])
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification['description'],
                              style: TextStyle(
                                color: darkGreen.withOpacity(0.7),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                color: darkGreen.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
