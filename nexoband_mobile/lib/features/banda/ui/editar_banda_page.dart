import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/model/grupo_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';

class EditarBandaPage extends StatefulWidget {
  final BandaResponse banda;

  const EditarBandaPage({super.key, required this.banda});

  @override
  State<EditarBandaPage> createState() => _EditarBandaPageState();
}

class _EditarBandaPageState extends State<EditarBandaPage> {
  final _formKey = GlobalKey<FormState>();
  final BandaService _bandaService = BandaService();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _generoCtrl;
  late final TextEditingController _descripcionCtrl;

  DateTime? _fechaCreacion;
  int? _categoriaId;

  List<GrupoResponse> _categorias = [];
  bool _cargandoCategorias = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final b = widget.banda;
    _nombreCtrl     = TextEditingController(text: b.nombre);
    _generoCtrl     = TextEditingController(text: b.genero ?? '');
    _descripcionCtrl = TextEditingController(text: b.descripcion ?? '');

    if (b.fecCreacion != null) {
      _fechaCreacion = DateTime.tryParse(b.fecCreacion!);
    }

    _categoriaId = b.categoria?.id;
    _cargarCategorias();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _generoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarCategorias() async {
    setState(() => _cargandoCategorias = true);
    try {
      final lista = await _bandaService.getGrupos();
      setState(() {
        _categorias = lista;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudieron cargar las categorías: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoCategorias = false);
    }
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaCreacion ?? ahora,
      firstDate: DateTime(1900),
      lastDate: ahora,
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFC7E39),
            onPrimary: Colors.white,
            surface: Color(0xFF2d2a28),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (fecha != null) setState(() => _fechaCreacion = fecha);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      final request = BandaRequest(
        nombre: _nombreCtrl.text.trim(),
        genero: _generoCtrl.text.trim().isEmpty ? null : _generoCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim().isEmpty
            ? null
            : _descripcionCtrl.text.trim(),
        fecCreacion: _fechaCreacion != null
            ? '${_fechaCreacion!.year.toString().padLeft(4, '0')}-'
                '${_fechaCreacion!.month.toString().padLeft(2, '0')}-'
                '${_fechaCreacion!.day.toString().padLeft(2, '0')}'
            : null,
        categoria: _categoriaId,
      );

      await _bandaService.editarBanda(widget.banda.id, request);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banda actualizada correctamente'),
          backgroundColor: Color(0xFF22c55e),
        ),
      );
      Navigator.of(context).pop(true); // true → recarga en la página anterior
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  InputDecoration _inputDeco(String label, {IconData? icono}) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: icono != null
            ? Icon(icono, color: Colors.white38, size: 20)
            : null,
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
      );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Editar banda',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _guardando
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
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
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _seccion('Información de la banda'),

              // Nombre
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _nombreCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco('Nombre *', icono: Icons.music_note_outlined),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                ),
              ),

              // Género
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _generoCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco('Género musical', icono: Icons.queue_music_outlined),
                ),
              ),

              // Descripción
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _descripcionCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: _inputDeco('Descripción', icono: Icons.notes_outlined),
                ),
              ),

              _seccion('Detalles'),

              // Fecha de creación
              GestureDetector(
                onTap: _seleccionarFecha,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2B29),
                    borderRadius: BorderRadius.circular(12),
                    border: _fechaCreacion != null
                        ? Border.all(color: const Color(0xFFFC7E39), width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: _fechaCreacion != null
                            ? const Color(0xFFFC7E39)
                            : Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _fechaCreacion != null
                            ? '${_fechaCreacion!.day.toString().padLeft(2, '0')}/'
                                '${_fechaCreacion!.month.toString().padLeft(2, '0')}/'
                                '${_fechaCreacion!.year}'
                            : 'Fecha de creación (opcional)',
                        style: TextStyle(
                          color: _fechaCreacion != null
                              ? Colors.white
                              : Colors.white38,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      if (_fechaCreacion != null)
                        GestureDetector(
                          onTap: () => setState(() => _fechaCreacion = null),
                          child: const Icon(Icons.close,
                              color: Colors.white38, size: 18),
                        ),
                    ],
                  ),
                ),
              ),

              // Categoría
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2B29),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _cargandoCategorias
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Color(0xFFFC7E39), strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('Cargando categorías...',
                                  style: TextStyle(color: Colors.white38)),
                            ],
                          ),
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _categoriaId,
                            hint: const Text(
                              'Categoría (opcional)',
                              style: TextStyle(color: Colors.white38, fontSize: 14),
                            ),
                            dropdownColor: const Color(0xFF2C2B29),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white38),
                            items: _categorias.map((g) {
                              return DropdownMenuItem<int>(
                                value: g.id,
                                child: Text(g.nombre,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _categoriaId = val),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
