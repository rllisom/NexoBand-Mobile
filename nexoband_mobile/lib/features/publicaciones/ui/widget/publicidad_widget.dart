import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';

class PublicidadWidget extends StatelessWidget {
  final Publicidad publicidad;

  const PublicidadWidget({super.key, required this.publicidad});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1D1817),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1D1817),
              const Color(0xFF1D1817).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFFFC7E39).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Etiqueta "Publicidad" ─────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'PUBLICIDAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    publicidad.icono,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Nombre empresa ─────────────────────────────────
              Text(
                publicidad.nombreEmpresa,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // ── Tipo empresa ───────────────────────────────────
              Text(
                publicidad.tipoEmpresa,
                style: const TextStyle(
                  color: Color(0xFFFC7E39),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              // ── Descripción ────────────────────────────────────
              Text(
                publicidad.descripcion,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // ── Botón de acción ────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí puedes abrir una URL, mostrar más info, etc.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Contacto: ${publicidad.emailContacto}'),
                          backgroundColor: const Color(0xFF232120),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Más información',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
