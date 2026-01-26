import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class RecentUpdatesScreen extends StatelessWidget {
  static const routeName = '/recent-updates';
  final List<Map<String, String>> updates;

  const RecentUpdatesScreen({super.key, required this.updates});

  @override
  Widget build(BuildContext context) {
    // Group updates by date
    final groupedUpdates = _groupUpdates(updates);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Recent Updates'),
        backgroundColor: saGovernmentGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedUpdates.length,
        itemBuilder: (context, index) {
          final group = groupedUpdates[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  group.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...group.items.map((update) => _buildUpdateCard(update)),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpdateCard(Map<String, String> update) {
    final type = update['type'] ?? 'feature';
    Color chipColor;
    String chipLabel;

    switch (type) {
      case 'feature':
        chipColor = Colors.blue;
        chipLabel = 'NEW';
        break;
      case 'fix':
        chipColor = Colors.orange;
        chipLabel = 'FIX';
        break;
      case 'content':
        chipColor = Colors.green;
        chipLabel = 'CONTENT';
        break;
      default:
        chipColor = Colors.grey;
        chipLabel = type.toUpperCase();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    chipLabel,
                    style: TextStyle(
                      color: chipColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  update['version'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              update['description'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<UpdateGroup> _groupUpdates(List<Map<String, String>> updates) {
    final groups = <String, List<Map<String, String>>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final update in updates) {
      final dateStr = update['date'];
      if (dateStr == null) continue;
      
      try {
        final date = DateTime.parse(dateStr);
        final dateOnly = DateTime(date.year, date.month, date.day);
        
        String groupTitle;
        if (dateOnly == today) {
          groupTitle = 'Today';
        } else if (dateOnly == yesterday) {
          groupTitle = 'Yesterday';
        } else if (today.difference(dateOnly).inDays < 7) {
          groupTitle = 'Last Week';
        } else {
          groupTitle = DateFormat('MMMM yyyy').format(date);
        }
        
        groups.putIfAbsent(groupTitle, () => []).add(update);
      } catch (e) {
        // Ignore invalid dates
      }
    }

    return groups.entries
        .map((e) => UpdateGroup(e.key, e.value))
        .toList();
  }
}

class UpdateGroup {
  final String title;
  final List<Map<String, String>> items;

  UpdateGroup(this.title, this.items);
}
