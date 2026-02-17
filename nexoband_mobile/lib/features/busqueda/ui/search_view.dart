import 'package:flutter/material.dart';
import 'search_musician_card_widget.dart';
import 'search_band_card_widget.dart';

class _NoResults extends StatelessWidget {
  final SearchTab tab;
  const _NoResults({required this.tab});

  @override
  Widget build(BuildContext context) {
    final text = tab == SearchTab.musicians
        ? 'No se encontraron músicos.'
        : 'No se encontraron bandas.';
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white54, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}


class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

enum SearchTab { musicians, bands }

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  SearchTab _selectedTab = SearchTab.musicians;
  String _search = '';

  // Simulación de resultados (reemplazar por integración backend)
  List<Map<String, dynamic>> get musicians => [
        {
          'name': 'Alex Rivera',
          'username': '@alexrivera',
          'img': 'https://randomuser.me/api/portraits/men/32.jpg',
          'tags': ['Guitarra eléctrica', 'Guitarra acústica'],
          'followers': 2547,
        },
        {
          'name': 'Carlos Mendez',
          'username': '@carlosmendez',
          'img': 'https://randomuser.me/api/portraits/men/44.jpg',
          'tags': ['Saxofón', 'Flauta'],
          'followers': 1678,
        },
      ];

  List<Map<String, dynamic>> get bands => [
        {
          'name': 'Jazz Collective',
          'desc': 'Explorando las fronteras',
          'img': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
          'tags': ['Jazz', 'Fusión', 'Experimental'],
          'followers': 3210,
        },
      ];

  List<Map<String, dynamic>> get filteredResults {
    if (_search.isEmpty) return [];
    final query = _search.toLowerCase();
    if (_selectedTab == SearchTab.musicians) {
      return musicians
          .where((m) => m['name'].toLowerCase().contains(query) ||
              m['username'].toLowerCase().contains(query) ||
              (m['tags'] as List).any((t) => t.toLowerCase().contains(query)))
          .toList();
    } else {
      return bands
          .where((b) => b['name'].toLowerCase().contains(query) ||
              (b['desc'] as String).toLowerCase().contains(query) ||
              (b['tags'] as List).any((t) => t.toLowerCase().contains(query)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMusicians = _selectedTab == SearchTab.musicians;
    final results = filteredResults;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          },
        ),
        title: const Text('Buscar', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar músicos, bandas, instrumentos...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = SearchTab.musicians),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMusicians ? Colors.grey[900] : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: isMusicians ? Colors.white : Colors.white54),
                          const SizedBox(width: 6),
                          Text('Músicos', style: TextStyle(color: isMusicians ? Colors.white : Colors.white54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = SearchTab.bands),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isMusicians ? Colors.grey[900] : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, color: !isMusicians ? Colors.white : Colors.white54),
                          const SizedBox(width: 6),
                          Text('Bandas', style: TextStyle(color: !isMusicians ? Colors.white : Colors.white54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _search.isEmpty
                ? _EmptyState(tab: _selectedTab)
                : results.isEmpty
                    ? _NoResults(tab: _selectedTab)
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: isMusicians
                                ? SearchMusicianCardWidget(data: item)
                                : SearchBandCardWidget(data: item),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final SearchTab tab;
  const _EmptyState({required this.tab});

  @override
  Widget build(BuildContext context) {
    final text = tab == SearchTab.musicians
        ? 'Busca músicos por nombre, instrumento o género...'
        : 'Busca bandas por nombre, descripción o género...';
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white54, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}

