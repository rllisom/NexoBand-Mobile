import 'package:flutter/material.dart';

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({super.key});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  final _nombreController = TextEditingController(text: 'Alex Rivera');
  final _usuarioController = TextEditingController(text: '@alexrivera');
  final _biografiaController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _instrumentoController = TextEditingController();

  final List<String> _instrumentos = ['Guitarra eléctrica', 'Guitarra acústica', 'Bajo'];
  final int _maxBio = 160;

  @override
  void dispose() {
    _nombreController.dispose();
    _usuarioController.dispose();
    _biografiaController.dispose();
    _ubicacionController.dispose();
    _instrumentoController.dispose();
    super.dispose();
  }

  void _agregarInstrumento() {
    final texto = _instrumentoController.text.trim();
    if (texto.isNotEmpty && !_instrumentos.contains(texto)) {
      setState(() {
        _instrumentos.add(texto);
        _instrumentoController.clear();
      });
    }
  }

  void _eliminarInstrumento(String instrumento) {
    setState(() => _instrumentos.remove(instrumento));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Editar perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A5A),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner + Avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Banner degradado
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF5A5A), Color(0xFFFF9A3C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Avatar
                Positioned(
                  bottom: -45,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF121212),
                            width: 3,
                          ),
                          color: const Color(0xFF3A3A3A),
                        ),
                        child: const ClipOval(
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A5A),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF121212),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Formulario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  _buildLabel('Nombre'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nombreController,
                    hint: 'Tu nombre',
                  ),
                  const SizedBox(height: 18),

                  // Nombre de usuario
                  _buildLabel('Nombre de usuario'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _usuarioController,
                    hint: '@usuario',
                  ),
                  const SizedBox(height: 18),

                  // Biografía
                  _buildLabel('Biografía'),
                  const SizedBox(height: 6),
                  _buildBiografiaField(),
                  const SizedBox(height: 18),

                  // Ubicación
                  _buildLabel('Ubicación'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _ubicacionController,
                    hint: 'Ciudad, País',
                  ),
                  const SizedBox(height: 18),

                  // Instrumentos
                  _buildLabel('Instrumentos'),
                  const SizedBox(height: 6),
                  _buildInstrumentosInput(),
                  const SizedBox(height: 12),
                  _buildInstrumentosChips(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildBiografiaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _biografiaController,
          maxLines: 4,
          maxLength: _maxBio,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Cuéntanos sobre ti...',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_biografiaController.text.length}/$_maxBio',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInstrumentosInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _instrumentoController,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Agregar instrumento',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            onSubmitted: (_) => _agregarInstrumento(),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _agregarInstrumento,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A5A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildInstrumentosChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _instrumentos
          .map(
            (instrumento) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    instrumento,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _eliminarInstrumento(instrumento),
                    child: const Icon(Icons.close, color: Colors.grey, size: 15),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
