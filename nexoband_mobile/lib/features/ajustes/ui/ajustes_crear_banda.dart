import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';

class AjustesCrearBanda extends StatefulWidget {
  const AjustesCrearBanda({super.key});

  @override
  State<AjustesCrearBanda> createState() => _AjustesCrearBandaState();
}

class _AjustesCrearBandaState extends State<AjustesCrearBanda> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _picker = ImagePicker();

  File? _imagenPerfil;
  String? _generoSeleccionado;
  DateTime? _fechaCreacion;
  bool _isLoading = false;

  final List<String> _generos = [
    'Rock', 'Metal', 'Pop', 'Indie', 'Hip-Hop', 'Jazz', 'Electrónica',
    'Folk', 'Clásica', 'Reggae', 'Punk', 'Blues', 'Fusión'
  ];

  Future<void> _seleccionarImagen() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagenPerfil = File(image.path);
      });
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFC7E39),
              onPrimary: Colors.white,
              surface: Color(0xFF232120),
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
        nombre: _nombreController.text,
        genero: _generoSeleccionado,
        fecCreacion: _fechaCreacion != null
            ? _fechaCreacion!.toIso8601String()
            : null,
        descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
        imgPerfil: _imagenPerfil,
      );
      await BandaService().crearBanda(
        bandaRequest,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Banda creada correctamente! 🎸'),
            backgroundColor: Color(0xFFFC7E39),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear Banda',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de perfil
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2A28),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: _imagenPerfil != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_imagenPerfil!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_note, color: Colors.white54, size: 48),
                            Text(
                              'Foto de banda',
                              style: TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                controller: _nombreController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Nombre de la banda *',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF232323),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFFC7E39)),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 20),

              // Género
              DropdownButtonFormField<String>(
                value: _generoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Género musical',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF232323),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFFC7E39)),
                  ),
                ),
                dropdownColor: const Color(0xFF232323),
                style: const TextStyle(color: Colors.white),
                items: _generos.map((genero) => DropdownMenuItem(
                  value: genero,
                  child: Text(genero),
                )).toList(),
                onChanged: (value) => setState(() => _generoSeleccionado = value),
              ),
              const SizedBox(height: 20),

              // Fecha creación
              GestureDetector(
                onTap: _seleccionarFecha,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232323),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fechaCreacion == null
                            ? 'Fecha de creación (opcional)'
                            : 'Creada: ${_fechaCreacion!.day}/${_fechaCreacion!.month}/${_fechaCreacion!.year}',
                        style: TextStyle(
                          color: _fechaCreacion == null ? Colors.white54 : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Descripción (opcional)',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF232323),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFFC7E39)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón Crear
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _crearBanda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC7E39),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Crear Banda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
