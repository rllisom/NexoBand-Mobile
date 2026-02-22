import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/perfil/bloc/perfil_bloc.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/perfil_body_widget.dart';

class PerfilDetailPage extends StatefulWidget {
  final int? usuarioId; // null = perfil propio, int = perfil ajeno

  const PerfilDetailPage({super.key, this.usuarioId});

  @override
  State<PerfilDetailPage> createState() => _PerfilDetailPageState();
}

class _PerfilDetailPageState extends State<PerfilDetailPage> {
  late final PerfilBloc _perfilBloc;
  Future<UsuarioResponse>? _futureUsuarioAjeno;

  bool get esPerfilAjeno => widget.usuarioId != null;

  @override
  void initState() {
    super.initState();
    if (esPerfilAjeno) {
      // Perfil ajeno — carga directa con UsuarioService
      _futureUsuarioAjeno = PerfilService().getUsuario(widget.usuarioId!);
    } else {
      // Perfil propio — usa el Bloc
      _perfilBloc = PerfilBloc(PerfilService())..add(CargarPerfil());
    }
  }

  @override
  void dispose() {
    if (!esPerfilAjeno) _perfilBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      body: esPerfilAjeno ? _buildPerfilAjeno() : _buildPerfilPropio(),
    );
  }

  // Perfil ajeno — FutureBuilder
  Widget _buildPerfilAjeno() {
    return FutureBuilder<UsuarioResponse>(
      future: _futureUsuarioAjeno,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar perfil', style: TextStyle(color: Colors.red)),
          );
        }
        return PerfilBodyWidget(
          usuario: snapshot.data!,
          esPerfilAjeno: true,
        );
      },
    );
  }


  Widget _buildPerfilPropio() {
    return BlocProvider.value(
      value: _perfilBloc,
      child: BlocBuilder<PerfilBloc, PerfilState>(
        builder: (context, state) {
          if (state is PerfilCargando || state is PerfilInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PerfilError) {
            return Center(
              child: Text(state.mensaje, style: const TextStyle(color: Colors.red)),
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
    );
  }
}

