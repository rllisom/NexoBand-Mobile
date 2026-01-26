import 'package:flutter/material.dart';
import 'package:nexoband_mobile/shared/publicacion_widget.dart';

class PublicacionView extends StatelessWidget {
  const PublicacionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Color(0xFF232120),
          child: Padding(
            padding: const EdgeInsets.only(top: 50,right: 10, left: 10,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Publicaciones",style: TextStyle(color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ Color(0xFFF13B57),Color(0xFFFC7E39),],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.add,color: Colors.white,) ,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              PublicacionWidget(imgPerfil: 'https://media.themoviedb.org/t/p/w300_and_h450_face/ozlEi4BXLTrPKrnQLdcMjdmSQaE.jpg' , nombreUser: 'Peter Claffey',
                horaPublicacion: "hace 2 horas", descripcion: "¡Acabamos de terminar la grabación de nuestro nuevo single! No puedo esperar a que lo escuchen. 🎤🎵",
                isMulti: false, img: "")
            ],
          ),
        )
      ],
    );
  }
}