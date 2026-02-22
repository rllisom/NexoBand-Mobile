import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';


class AjustesSeguidoresView extends StatelessWidget {
  final List<SeguidorResponse> lista;
  final String titulo; // "Seguidores" o "Seguidos"

  const AjustesSeguidoresView({
    super.key,
    required this.lista,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: lista.isEmpty
          ? const Center(child: Text('No hay usuarios'))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final usuario = lista[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: usuario.imgPerfil != null
                        ? NetworkImage(usuario.imgPerfil!)
                        : null,
                    child: usuario.imgPerfil == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text('${usuario.nombre} ${usuario.apellidos}'),
                  subtitle: Text('@${usuario.username}'),
                );
              },
            ),
    );
  }
}
