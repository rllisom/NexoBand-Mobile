// widgets/crear_publicacion_modal.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';

class CrearPublicacionModal extends StatefulWidget {
  final UsuarioResponse usuarioActual;
  final List<BandaEnUsuarioResponse> bandasUsuario;
  final Function(String texto, String? autorId, String? autorTipo, XFile? multimedia) onPublicar;

  const CrearPublicacionModal({
    super.key,
    required this.usuarioActual,
    required this.bandasUsuario,
    required this.onPublicar,
  });

  @override
  State<CrearPublicacionModal> createState() => _CrearPublicacionModalState();
}

class _CrearPublicacionModalState extends State<CrearPublicacionModal> {
  final TextEditingController _textoController = TextEditingController();
  String? _autorSeleccionadoId;
  String _autorSeleccionadoTipo = 'usuario'; 
  XFile? _multimediaSeleccionada;
  final ImagePicker _picker = ImagePicker();


  String limpiarUrlImagen(String? url, {String carpeta = 'perfiles'}) {
    if (url == null || url.isEmpty) return '';
    final filename = url.split('/').last;
    if (filename.isEmpty) return '';
    return 'http://10.0.2.2:8000/storage/$carpeta/$filename';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1d1817),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: 500,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Publicar como:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _autorSeleccionadoTipo == 'usuario'
                    ? 'usuario_${widget.usuarioActual.id}'
                    : (_autorSeleccionadoId != null
                        ? 'banda_$_autorSeleccionadoId'
                        : null),
                hint: const Text('Selecciona quién publica', style: TextStyle(color: Colors.grey)),
                items: [
                  // Usuario actual
                  DropdownMenuItem(
                    value: 'usuario_${widget.usuarioActual.id}',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: widget.usuarioActual.imgPerfil != null
                              ? NetworkImage(limpiarUrlImagen(widget.usuarioActual.imgPerfil, carpeta: 'perfiles'))
                              : null,
                          child: widget.usuarioActual.imgPerfil == null
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.usuarioActual.nombre + ' ' + widget.usuarioActual.apellidos,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('@${widget.usuarioActual.username}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bandas
                  ...widget.bandasUsuario.map((banda) => DropdownMenuItem(
                    value: 'banda_${banda.id}',
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.music_note, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(banda.nombre,style: TextStyle(color: Colors.white),),
                              Text('Banda', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      final partes = value.split('_');
                      _autorSeleccionadoTipo = partes[0];
                      _autorSeleccionadoId = partes[1];
                    });
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          //Input texto
          TextField(
            controller: _textoController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '¿Qué quieres compartir?',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[900],
            ),
          ),
          
          const SizedBox(height: 20),
          
          //Multimedia
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton.icon(
              onPressed: _seleccionarMultimedia,
              icon: _multimediaSeleccionada != null 
                  ? const Icon(Icons.check, color: Colors.green) 
                  : const Icon(Icons.add_photo_alternate, color: Colors.white),
              label: Text(_multimediaSeleccionada != null 
                  ? 'Cambiar multimedia' 
                  : 'Añadir foto/video',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          if (_multimediaSeleccionada != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, color: Color(0xFFFC7E39), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _multimediaSeleccionada!.name,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _multimediaSeleccionada = null),
                    child: const Icon(Icons.close, color: Colors.white38, size: 18),
                  ),
                ],
              ),
            ),
          ],
          
          const Spacer(),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _publicar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Publicar'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _seleccionarMultimedia() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _multimediaSeleccionada = imagen;
      });
    }
  }

  void _publicar() {
    widget.onPublicar(
      _textoController.text.trim(),
      _autorSeleccionadoId,
      _autorSeleccionadoTipo,
      _multimediaSeleccionada,
    );
    Navigator.pop(context);
  }
}
