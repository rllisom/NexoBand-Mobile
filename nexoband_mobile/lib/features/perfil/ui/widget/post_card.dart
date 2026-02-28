import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/features/perfil/bloc/perfil_bloc.dart';

class PostCard extends StatelessWidget {
  final Publicacion publicacion;

  const PostCard({super.key, required this.publicacion});

  Future<bool> _comprobarSiEsMia(BuildContext context) async {
    final perfilState = BlocProvider.of<PerfilBloc>(context).state;
    if (perfilState is PerfilCargado) {
      return perfilState.usuario.id == publicacion.user?.id;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final nombre = publicacion.banda?.nombre ??
        '${publicacion.user?.nombre ?? ''} ${publicacion.user?.apellidos ?? ''}'.trim();
    final imagen = publicacion.banda?.imgPerfil ?? publicacion.user?.imgPerfil;
    final tieneImagen = publicacion.multimedia?.url != null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: imagen != null
                        ? Image.network(
                            imagen,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[800],
                              child: const Icon(Icons.person,
                                  color: Colors.white54, size: 20),
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[800],
                            child: const Icon(Icons.person,
                                color: Colors.white54, size: 20),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      if (publicacion.user?.username != null)
                        Text(
                          '@${publicacion.user!.username}',
                          style: const TextStyle(
                              color: Color(0xFF9ca3af), fontSize: 12),
                        ),
                      Text(
                        _timeAgo(publicacion.createdAt),
                        style: const TextStyle(
                            color: Color(0xFF9ca3af), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              FutureBuilder<bool>(
                future: _comprobarSiEsMia(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snapshot.hasData && snapshot.data == true) {
                    return IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 15,),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar publicación'),
                            content: const Text('¿Estás seguro de que quieres eliminar esta publicación?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try{
                                    await PublicacionService().eliminarPublicacion(publicacion.id);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      BlocProvider.of<PerfilBloc>(context).add(CargarPerfil());
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Publicación eliminada')),
                                      );
                                    }
                                  }catch(e){
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al eliminar: $e')),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
            ],
          ),
          // Contenido
          if (publicacion.contenido != null) ...[
            const SizedBox(height: 10),
            Text(
              publicacion.contenido!,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, height: 1.4),
            ),
          ],
          // Imagen multimedia
          if (tieneImagen) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                publicacion.multimedia!.url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Acciones — solo comentarios
          Row(
            children: [
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                count: publicacion.comentarios.length,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} horas';
    return 'Hace ${diff.inDays} días';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;

  const _ActionButton({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF9ca3af), size: 20),
        const SizedBox(width: 4),
        Text('$count',
            style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
      ],
    );
  }
}
