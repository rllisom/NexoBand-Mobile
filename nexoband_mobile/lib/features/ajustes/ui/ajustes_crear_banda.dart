import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/model/grupo_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';

class AjustesCrearBanda extends StatefulWidget {
  const AjustesCrearBanda({super.key});

  @override
  State<AjustesCrearBanda> createState() => _AjustesCrearBandaState();
}

class _AjustesCrearBandaState extends State<AjustesCrearBanda> {
  static const _orange = Color(0xFFFC7E39);
  static const _bg = Color(0xFF0F0F10);
  static const _card = Color(0xFF1C1B1A);
  static const _field = Color(0xFF242220);
  static const _border = Color(0xFF2E2C2A);

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _generoController = TextEditingController();
  final _descripcionController = TextEditingController();


  File? _imagenPerfil;
  DateTime? _fechaCreacion;
  bool _isLoading = false;

  List<GrupoResponse> _grupos = [];
  int? _grupoSeleccionadoId;
  bool _loadingGrupos = false;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _generoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _cargarGrupos() async {
    setState(() => _loadingGrupos = true);
    try {
      final grupos = await BandaService().getGrupos();
      setState(() => _grupos = grupos);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar las categorías'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() => _loadingGrupos = false);
    }
  }


  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _orange,
              onPrimary: Colors.white,
              surface: Color(0xFF2A2826),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _fechaCreacion = picked);
    }
  }

  Future<void> _crearBanda() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bandaRequest = BandaRequest(
        nombre: _nombreController.text.trim(),
        genero: _generoController.text.trim().isEmpty ? null : _generoController.text.trim(),
        fecCreacion: _fechaCreacion != null
            ? '${_fechaCreacion!.year}-${_fechaCreacion!.month.toString().padLeft(2, '0')}-${_fechaCreacion!.day.toString().padLeft(2, '0')}'
            : null,
        descripcion: _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim(),
        imgPerfil: _imagenPerfil,
        categoria: _grupoSeleccionadoId,
      );
      await BandaService().crearBanda(bandaRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('¡Banda creada correctamente!'),
              ],
            ),
            backgroundColor: _orange,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Helpers de UI ────────────────────────────────────────────────────

  InputDecoration _fieldDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF7A7874), fontSize: 14),
      prefixIcon: icon != null
          ? Icon(icon, color: const Color(0xFF5A5856), size: 20)
          : null,
      filled: true,
      fillColor: _field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF7A7874),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nueva Banda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: _border, height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Información básica ─────────────────────────────────
              _sectionLabel('INFORMACIÓN BÁSICA'),
              Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: _fieldDecoration(
                        'Nombre de la banda *',
                        icon: Icons.group_rounded,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _generoController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: _fieldDecoration(
                        'Estilos musicales (opcional)',
                        icon: Icons.queue_music_rounded,
                      ).copyWith(
                        hintText: 'Ej: Rock, Metal, Indie…',
                        hintStyle: const TextStyle(color: Color(0xFF4A4846), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Detalles ───────────────────────────────────────────
              _sectionLabel('DETALLES'),
              Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  children: [
                    // Fecha de creación
                    InkWell(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      onTap: _seleccionarFecha,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded,
                                color: Color(0xFF5A5856), size: 20),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _fechaCreacion == null
                                    ? 'Fecha de creación (opcional)'
                                    : '${_fechaCreacion!.day.toString().padLeft(2, '0')}/${_fechaCreacion!.month.toString().padLeft(2, '0')}/${_fechaCreacion!.year}',
                                style: TextStyle(
                                  color: _fechaCreacion == null
                                      ? const Color(0xFF7A7874)
                                      : Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (_fechaCreacion != null)
                              GestureDetector(
                                onTap: () => setState(() => _fechaCreacion = null),
                                child: const Icon(Icons.close_rounded,
                                    color: Color(0xFF7A7874), size: 18),
                              )
                            else
                              const Icon(Icons.chevron_right_rounded,
                                  color: Color(0xFF5A5856), size: 20),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, color: _border),
                    // Categoría
                    if (_loadingGrupos)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: _orange,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        child: DropdownButtonFormField<int>(
                          value: _grupoSeleccionadoId,
                          decoration: _fieldDecoration(
                            'Categoría (opcional)',
                            icon: Icons.category_rounded,
                          ),
                          dropdownColor: const Color(0xFF2A2826),
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          icon: const Icon(Icons.expand_more_rounded,
                              color: Color(0xFF5A5856)),
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                'Sin categoría',
                                style: TextStyle(color: Color(0xFF7A7874)),
                              ),
                            ),
                            ..._grupos.map(
                              (g) => DropdownMenuItem<int>(
                                value: g.id,
                                child: Text(g.nombre),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => _grupoSeleccionadoId = v),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Descripción ────────────────────────────────────────
              _sectionLabel('DESCRIPCIÓN'),
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                maxLength: 500,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                decoration: _fieldDecoration('Cuéntanos sobre la banda…').copyWith(
                  alignLabelWithHint: true,
                  counterStyle: const TextStyle(color: Color(0xFF5A5856)),
                ),
              ),
              const SizedBox(height: 24),

              // ── Botón crear ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _crearBanda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    disabledBackgroundColor: _orange.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Crear Banda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
