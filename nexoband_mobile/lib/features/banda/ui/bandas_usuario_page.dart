import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/features/ajustes/ui/ajustes_crear_banda.dart';
import 'package:nexoband_mobile/features/banda/ui/widget/banda_card.dart';

class BandasUsuarioPage extends StatelessWidget {
  final List<BandaEnUsuarioResponse> bandas;

  const BandasUsuarioPage({super.key, required this.bandas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        elevation: 0,
        title: const Text(
          'Mis bandas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFef365b), Color(0xFFfd8835)],
                ),
              ),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AjustesCrearBanda()));
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text(
                  'Nueva banda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: bandas.isEmpty
          ? const Center(
              child: Text(
                'Todavía no perteneces a ninguna banda',
                style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bandas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final banda = bandas[index];
                return BandaCard(banda: banda);
              },
            ),
    );
  }
}
