import 'package:flutter/material.dart';

class PublicacionWidget extends StatefulWidget {
  final String imgPerfil;
  final String nombreUser;
  final String horaPublicacion;
  final String descripcion;
  final String img;
  final int comentarios;

  const PublicacionWidget({
    super.key,
    required this.imgPerfil,
    required this.nombreUser,
    required this.horaPublicacion,
    required this.descripcion,
    required this.img,
    required this.comentarios
    });

  @override
  State<PublicacionWidget> createState() => PublicacionWidgetState();
}

class PublicacionWidgetState extends State<PublicacionWidget> {
  Color like = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF232120),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    widget.imgPerfil,
                    scale: 10,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nombreUser,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        widget.horaPublicacion,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            Text(
              widget.descripcion,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Row(
                children: [
                  Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  Text(
                    "${widget.comentarios}",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}