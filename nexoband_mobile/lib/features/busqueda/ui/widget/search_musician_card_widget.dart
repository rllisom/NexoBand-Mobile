import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/model/usuario_search_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/busqueda/ui/widget/search_tag_widget.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_ajeno_page.dart';


class SearchMusicianCardWidget extends StatelessWidget {
  final UsuarioSearchResponse usuario;

  const SearchMusicianCardWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final nombreCompleto = '${usuario.nombre} ${usuario.apellidos}';
    final instrumentos = usuario.instrumentos
        .map((i) => i['nombre'] as String)
        .toList();
    

    return GestureDetector(
      onTap: () async {
        final UsuarioResponse perfil = await PerfilService().getUsuario(usuario.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PerfilAjenoPage(usuario: perfil), 
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[800],
              backgroundImage: usuario.imgPerfil != null
                  ? NetworkImage(usuario.imgPerfil!)
                  : null,
              child: usuario.imgPerfil == null
                  ? const Icon(Icons.person, color: Colors.white54, size: 28)
                  : null,
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y username
                  Text(
                    nombreCompleto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${usuario.username}',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  // Tags de instrumentos
                  if (instrumentos.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: instrumentos
                          .take(3) // máximo 3 tags visibles
                          .map((nombre) => Tag(label: nombre))
                          .toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Seguidores
            Column(
              children: [
                const Icon(Icons.people, color: Colors.white54, size: 16),
                const SizedBox(height: 2),
                Text(
                  '${usuario.seguidoresCount}',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
