import 'package:flutter/material.dart';
import 'package:nexoband_mobile/features/ajustes/ui/ajustes_megusta_view.dart';
import 'package:nexoband_mobile/features/ajustes/ui/ajustes_seguidores_view.dart';
import 'package:nexoband_mobile/features/ajustes/ui/ajustes_siguiendo_view.dart';
import 'package:nexoband_mobile/features/ajustes/ui/editar_perfil_view.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_detail_page.dart';
import 'package:nexoband_mobile/features/banda/ui/bandas_usuario_page.dart';
import 'package:nexoband_mobile/features/login/ui/login_page_view.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_detail_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const EditarPerfilView(),
    );
  }
}
