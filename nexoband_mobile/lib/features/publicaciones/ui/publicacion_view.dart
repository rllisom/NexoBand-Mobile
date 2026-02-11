import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_list_response.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/publicacion_widget.dart';


class PublicacionView extends StatelessWidget {
  final List<Publicacion> publicacion;
  const PublicacionView({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    if (publicacion.isEmpty) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFF232120),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Publicaciones",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'No hay publicaciones disponibles',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }
    
    return ListView.builder(
      itemCount: publicacion.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header
          return Container(
            width: double.infinity,
            color: Color(0xFF232120),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Publicaciones",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          final pub = publicacion[index - 1];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PublicacionWidget(
              imgPerfil: pub.user?.imgPerfil != null
                  ? pub.user!.imgPerfil!
                  : 'https://marketplace.canva.com/A5alg/MAESXCA5alg/1/tl/canva-user-icon-MAESXCA5alg.png',
              nombreUser: pub.user?.nombre ?? 'Usuario Desconocido',
              horaPublicacion: '${pub.createdAt.hour}:${pub.createdAt.minute}',
              descripcion: pub.contenido,
              img: pub.multimedia?.url ?? '',
              comentarios: pub.comentarios.length,
            ),
          );
        }
      },
    );
  }
}