import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/banda/bloc/banda_bloc.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_ajeno_page.dart';

class MiembroCard extends StatelessWidget {
  final UsuarioBanda miembro;
  final int bandaId;

  const MiembroCard({super.key,required this.miembro, required this.bandaId});

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
              ],
            ),
          ),
          FutureBuilder<bool>(
            future: _esPropietario(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (snapshot.hasData && snapshot.data == true) {
                return FutureBuilder<int>(
                  future: _getUsuarioId(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (userSnapshot.hasData && miembro.id != userSnapshot.data) {
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent.withOpacity(0.8),
                            ),
                            onPressed: () {
                              final bandaBloc = context.read<BandaBloc>();
                              showDialog(
                                context: context,
                                builder: (dialogCtx) => AlertDialog(
                                  title: const Text('Eliminar miembro'),
                                  content: Text(
                                      '¿Estás seguro de que quieres eliminar a ${miembro.nombre} ${miembro.apellidos} de la banda?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogCtx),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        bandaBloc.add(EliminarMiembroBanda(bandaId, miembro.id));
                                        bandaBloc.add(LoadBandaDetail(bandaId));
                                        Navigator.pop(dialogCtx);
                                      },
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),          
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF9ca3af)),
            onPressed: () async {
              UsuarioResponse usuario = await perfilService.getUsuario(
                miembro.id,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PerfilAjenoPage(usuario: usuario),
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

  Future<int> _getUsuarioId() async {
    return await GuardarToken.getUsuarioId();
  }

    Future<bool> _esPropietario() async {
    final usuarioId = await GuardarToken.getUsuarioId();
    
    final BandaResponse bandaDetails = await BandaService().getBandaDetail(bandaId);
    return bandaDetails.usuarios.any((u) => u.id == usuarioId);
  }
}
