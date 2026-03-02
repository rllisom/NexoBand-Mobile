import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/instrumento_service.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/perfil/bloc/perfil_bloc.dart';

class AjustesEditarPerfil extends StatefulWidget {
  const AjustesEditarPerfil({super.key});

  @override
  State<AjustesEditarPerfil> createState() => _AjustesEditarPerfilState();
}

class _AjustesEditarPerfilState extends State<AjustesEditarPerfil> {
  late PerfilBloc _perfilBloc;
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl       = TextEditingController();
  final _apellidosCtrl    = TextEditingController();
  final _usernameCtrl     = TextEditingController();
  final _emailCtrl        = TextEditingController();
  final _passwordCtrl     = TextEditingController();
  final _descripcionCtrl  = TextEditingController();
  final _telefonoCtrl     = TextEditingController();
  final _direccionCtrl    = TextEditingController();
  final _provinciaCtrl    = TextEditingController();
  final _nacionalidadCtrl = TextEditingController();

  bool _mostrarPassword = false;
  int? _usuarioId;

  // ── Instrumentos ──────────────────────────────────
  final InstrumentoService _instrumentoService = InstrumentoService();
  List<InstrumentoResponse> _misInstrumentos = [];
  List<InstrumentoResponse> _todosInstrumentos = [];
  InstrumentoResponse? _instrumentoSeleccionado;
  bool _cargandoInstrumentos = false;

  @override
  void initState() {
    super.initState();
    _perfilBloc = PerfilBloc(PerfilService())..add(CargarPerfil());
    _cargarTodosInstrumentos();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _descripcionCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _provinciaCtrl.dispose();
    _nacionalidadCtrl.dispose();
    _perfilBloc.close();
    super.dispose();
  }

  void _rellenarCampos(PerfilCargado state) {
    _usuarioId              = state.usuario.id;
    _nombreCtrl.text        = state.usuario.nombre;
    _apellidosCtrl.text     = state.usuario.apellidos;
    _usernameCtrl.text      = state.usuario.username;
    _emailCtrl.text         = state.usuario.email;
    _descripcionCtrl.text   = state.usuario.descripcion ?? '';
    _telefonoCtrl.text      = state.usuario.telefono ?? '';
    _direccionCtrl.text     = state.usuario.direccion ?? '';
    _provinciaCtrl.text     = state.usuario.provincia ?? '';
    _nacionalidadCtrl.text  = state.usuario.nacionalidad ?? '';
    setState(() {
      _misInstrumentos = List.of(state.usuario.instrumentos);
    });
  }

  Future<void> _cargarTodosInstrumentos() async {
    try {
      final todos = await _instrumentoService.listarTodos();
      if (mounted) setState(() => _todosInstrumentos = todos);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudieron cargar los instrumentos: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    }
  }

  Future<void> _agregarInstrumento() async {
    if (_instrumentoSeleccionado == null || _usuarioId == null) return;

    // Campos del diálogo
    String nivelSeleccionado = 'medio';
    final experienciaCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    final generosCtrl     = TextEditingController();
    final dialogFormKey   = GlobalKey<FormState>();

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          backgroundColor: const Color(0xFF232120),
          title: Text(
            'Agregar ${_instrumentoSeleccionado!.nombre}',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nivel
                  DropdownButtonFormField<String>(
                    value: nivelSeleccionado,
                    dropdownColor: const Color(0xFF2C2B29),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco('Nivel'),
                    items: ['bajo', 'medio', 'alto'].map((n) => DropdownMenuItem(
                      value: n,
                      child: Text(n, style: const TextStyle(color: Colors.white)),
                    )).toList(),
                    onChanged: (v) => setModalState(() => nivelSeleccionado = v ?? 'medio'),
                  ),
                  const SizedBox(height: 12),
                  // Experiencia (años) — requerido
                  TextFormField(
                    controller: experienciaCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco('Años de experiencia'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Campo requerido';
                      if (int.tryParse(v.trim()) == null) return 'Introduce un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Géneros — requerido
                  TextFormField(
                    controller: generosCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco('Géneros (ej: rock, jazz)'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  // Descripción — opcional
                  TextFormField(
                    controller: descripcionCtrl,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: _inputDeco('Descripción (opcional)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  if (dialogFormKey.currentState!.validate()) {
                    Navigator.of(ctx).pop(true);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmado != true) return;

    setState(() => _cargandoInstrumentos = true);
    try {
      await _instrumentoService.agregarAUsuario(
        usuarioId:      _usuarioId!,
        instrumentoId:  _instrumentoSeleccionado!.id,
        nivel:          nivelSeleccionado,
        experiencia:    int.tryParse(experienciaCtrl.text.trim()) ?? 0,
        descripcion:    descripcionCtrl.text.trim(),
        generos:        generosCtrl.text.trim(),
      );
      _perfilBloc.add(CargarPerfil());
      setState(() => _instrumentoSeleccionado = null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoInstrumentos = false);
    }
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2C2B29),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFC7E39), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );

  Future<void> _eliminarInstrumento(int instrumentoId) async {
    _usuarioId ??= await GuardarToken.getUsuarioId();
    if (_usuarioId == null) return;
    setState(() => _cargandoInstrumentos = true);
    try {
      await _instrumentoService.eliminarDeUsuario(_usuarioId!, instrumentoId);
      setState(() {
        _misInstrumentos.removeWhere((i) => i.id == instrumentoId);
      });
      _perfilBloc.add(CargarPerfil());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoInstrumentos = false);
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate() || _usuarioId == null) return;

    final datos = <String, String>{
      'nombre':       _nombreCtrl.text.trim(),
      'apellidos':    _apellidosCtrl.text.trim(),
      'username':     _usernameCtrl.text.trim(),
      'email':        _emailCtrl.text.trim(),
      'descripcion':  _descripcionCtrl.text.trim(),
      'telefono':     _telefonoCtrl.text.trim(),
      'direccion':    _direccionCtrl.text.trim(),
      'provincia':    _provinciaCtrl.text.trim(),
      'nacionalidad': _nacionalidadCtrl.text.trim(),
    };

    if (_passwordCtrl.text.isNotEmpty) {
      datos['password'] = _passwordCtrl.text;
    }

    _perfilBloc.add(EditarDatosPerfil(_usuarioId!, datos));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _perfilBloc,
      child: BlocConsumer<PerfilBloc, PerfilState>(
        listener: (context, state) {
          if (state is PerfilCargado) _rellenarCampos(state);
          if (state is PerfilGuardado) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil actualizado correctamente'),
                backgroundColor: Color(0xFF22c55e),
              ),
            );
            Navigator.of(context).pop();
          }
          if (state is PerfilGuardadoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.mensaje}'),
                backgroundColor: const Color(0xFFef365b),
              ),
            );
          }
        },
        builder: (context, state) {
          final cargando  = state is PerfilCargando;
          final guardando = state is PerfilGuardando;

          return Scaffold(
            backgroundColor: const Color(0xFF1D1817),
            appBar: AppBar(
              backgroundColor: const Color(0xFF232120),
              foregroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Editar perfil',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              actions: [
                if (!cargando)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: guardando
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              onPressed: _guardar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              child: const Text(
                                'Guardar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                  ),
              ],
            ),
            body: cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFC7E39)),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _seccion('Información personal'),
                          _campo(
                            controller: _nombreCtrl,
                            label: 'Nombre',
                            icono: Icons.person_outline,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _apellidosCtrl,
                            label: 'Apellidos',
                            icono: Icons.person_outline,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _usernameCtrl,
                            label: 'Nombre de usuario',
                            icono: Icons.alternate_email,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _descripcionCtrl,
                            label: 'Descripción / Bio',
                            icono: Icons.notes,
                            maxLines: 3,
                          ),
                          _seccion('Cuenta'),
                          _campo(
                            controller: _emailCtrl,
                            label: 'Email',
                            icono: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Campo requerido';
                              if (!v.contains('@')) return 'Email no válido';
                              return null;
                            },
                          ),
                          _campoPassword(),
                          _seccion('Contacto y ubicación'),
                          _campo(
                            controller: _telefonoCtrl,
                            label: 'Teléfono',
                            icono: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _direccionCtrl,
                            label: 'Dirección',
                            icono: Icons.home_outlined,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _provinciaCtrl,
                            label: 'Provincia',
                            icono: Icons.location_city_outlined,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _campo(
                            controller: _nacionalidadCtrl,
                            label: 'Nacionalidad',
                            icono: Icons.flag_outlined,
                            validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                          ),
                          _seccion('Instrumentos'),
                          _seccionInstrumentos(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _seccion(String titulo) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFFFC7E39),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            prefixIcon: Icon(icono, color: Colors.white38, size: 20),
            filled: true,
            fillColor: const Color(0xFF2C2B29),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFC7E39), width: 1.5),
            ),
            errorStyle: const TextStyle(color: Color(0xFFef365b)),
          ),
        ),
      );

  Widget _seccionInstrumentos() {

    final misIds = _misInstrumentos.map((i) => i.id).toSet();


    final disponibles = _todosInstrumentos
        .where((i) => !misIds.contains(i.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Chips de instrumentos actuales ────────────────────
        if (_misInstrumentos.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Agrega instrumentos',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _misInstrumentos.map((inst) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2B29),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFC7E39), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note, color: Color(0xFFFC7E39), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        inst.nombre,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _cargandoInstrumentos
                            ? null
                            : () => _eliminarInstrumento(inst.id),
                        child: const Icon(Icons.close, color: Colors.white54, size: 15),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        // ── Dropdown + botón agregar ──────────────────────────
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2B29),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<InstrumentoResponse>(
                    value: _instrumentoSeleccionado,
                    hint: const Text(
                      'Selecciona un instrumento',
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                    dropdownColor: const Color(0xFF2C2B29),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
                    items: disponibles.map((inst) {
                      return DropdownMenuItem(
                        value: inst,
                        child: Text(
                          inst.nombre,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: disponibles.isEmpty
                        ? null
                        : (val) => setState(() => _instrumentoSeleccionado = val),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _cargandoInstrumentos
                ? const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFC7E39),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _instrumentoSeleccionado == null
                          ? null
                          : _agregarInstrumento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      icon: const Icon(Icons.add, size: 18,color: Colors.white,),
                      label: const Text('Agregar',style: TextStyle(color: Colors.white),),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _campoPassword() => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: _passwordCtrl,
          obscureText: !_mostrarPassword,
          style: const TextStyle(color: Colors.white),
          validator: (v) {
            if (v != null && v.isNotEmpty && v.length < 8) {
              return 'Mínimo 8 caracteres';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Nueva contraseña (opcional)',
            labelStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white38, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _mostrarPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white38,
                size: 20,
              ),
              onPressed: () => setState(() => _mostrarPassword = !_mostrarPassword),
            ),
            filled: true,
            fillColor: const Color(0xFF2C2B29),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFC7E39), width: 1.5),
            ),
            errorStyle: const TextStyle(color: Color(0xFFef365b)),
          ),
        ),
      );
}