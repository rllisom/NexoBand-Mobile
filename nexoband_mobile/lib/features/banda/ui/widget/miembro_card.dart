import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_ajeno_page.dart';

class MiembroCard extends StatelessWidget {
  final UsuarioBanda miembro;

  const MiembroCard({
    super.key,
    required this.miembro,
  
  });

  @override
  Widget build(BuildContext context) {
    final PerfilService perfilService = PerfilService();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: miembro.imgPerfil != null
                ? Image.network(
                    miembro.imgPerfil!,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${miembro.nombre} ${miembro.apellidos}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  miembro.rol ?? '@${miembro.username}',
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF9ca3af)),
            onPressed: () async{
              UsuarioResponse usuario = await perfilService.getUsuario(miembro.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PerfilAjenoPage(
                    usuario: usuario,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 46,
      height: 46,
      color: const Color(0xFF2d2a28),
      child: const Icon(Icons.person, color: Color(0xFF9ca3af), size: 24),
    );
  }
}
