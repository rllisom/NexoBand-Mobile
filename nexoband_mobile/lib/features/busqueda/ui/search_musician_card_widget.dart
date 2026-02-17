import 'package:flutter/material.dart';

class SearchMusicianCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const SearchMusicianCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(data['img']),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(data['username'], style: const TextStyle(color: Colors.white54, fontSize: 15)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: (data['tags'] as List).map<Widget>((tag) => Chip(
                      label: Text(tag, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.grey[800],
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${data['followers']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const Text('seguidores', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}