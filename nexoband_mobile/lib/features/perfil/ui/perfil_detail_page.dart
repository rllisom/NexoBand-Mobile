import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/perfil/bloc/perfil_bloc.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/perfil_body_widget.dart';


class PerfilDetailPage extends StatefulWidget {
  const PerfilDetailPage({super.key});

  @override
  State<PerfilDetailPage> createState() => _PerfilDetailPageState();
}

class _PerfilDetailPageState extends State<PerfilDetailPage> {
  late final PerfilBloc _perfilBloc;

  @override
  void initState() {
    super.initState();
    _perfilBloc = PerfilBloc(PerfilService())..add(CargarPerfil());
  }

  @override
  void dispose() {
    _perfilBloc.close();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      body: BlocProvider.value(
        value: _perfilBloc,
        child: BlocBuilder<PerfilBloc, PerfilState>(
          buildWhen: (_, state) =>
              state is PerfilInitial ||
              state is PerfilCargando ||
              state is PerfilCargado ||
              state is PerfilError,
          builder: (context, state) {
            if (state is PerfilCargando || state is PerfilInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFC7E39),
                ),
              );
            } else if (state is PerfilError) {
              return Center(
                child: Text(
                  state.mensaje,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is PerfilCargado) {
              return PerfilBodyWidget(
                usuario: state.usuario,
                esPerfilAjeno: false,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

