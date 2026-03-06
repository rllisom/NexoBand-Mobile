import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/dto/chat_request.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/features/banda/ui/bandas_ajenas_page.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_detail_view.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilAjenoPage extends StatefulWidget {
  final UsuarioResponse usuario;

  const PerfilAjenoPage({super.key, required this.usuario});

  @override
  State<PerfilAjenoPage> createState() => _PerfilAjenoPageState();
}

class _PerfilAjenoPageState extends State<PerfilAjenoPage> {
  final PageController _headerPageCtrl = PageController();
  int _headerPage = 0;

  @override
  void dispose() {
    _headerPageCtrl.dispose();
    super.dispose();
  }

  Future<int?> _obtenerMyUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> _iniciarChat(BuildContext context) async {
    final myUserId = await _obtenerMyUserId();
    if (myUserId == null) return;
    try {
      final chat = await ChatService().crearChat(ChatRequest(
        nombre: null,
        usuario1Id: myUserId,
        usuario2Id: widget.usuario.id,
      ));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatDetailView(chat: chat)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _infoRow(IconData icono, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFFFC7E39), size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;

    return Scaffold(
      backgroundColor: const Color(0xFF1D1817),
      body: SafeArea(
        bottom: false,
        child: Column(
        children: [
          // ── AppBar custom ─────────────────────────────────────
          Container(
            color: const Color(0xFF232120),
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                  onPressed: () => _iniciarChat(context),
                ),
              ],
            ),
          ),

          // ── Cabecera del perfil ───────────────────────────────
          Container(
            color: const Color(0xFF232120),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header deslizable ─────────────────────────
                SizedBox(
                  height: 140,
                  child: PageView(
                    controller: _headerPageCtrl,
                    onPageChanged: (p) => setState(() => _headerPage = p),
                    children: [
                      // ── Página 0: Avatar + nombre ─────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipOval(
                              child: usuario.imgPerfil != null
                                  ? Image.network(
                                      usuario.imgPerfil!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                    )
                                  : _avatarPlaceholder(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${usuario.nombre} ${usuario.apellidos}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: -0.44,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${usuario.username}',
                                  style: const TextStyle(
                                    color: Color(0xFF9ca3af),
                                    fontSize: 16,
                                    letterSpacing: -0.31,
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // ── Página 1: Datos de contacto ───────────
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (usuario.email.isNotEmpty)
                              _infoRow(Icons.email_outlined, usuario.email),
                            if (usuario.telefono != null && usuario.telefono!.isNotEmpty)
                              _infoRow(Icons.phone_outlined, usuario.telefono!),
                            if (usuario.provincia != null && usuario.provincia!.isNotEmpty)
                              _infoRow(Icons.location_city_outlined, usuario.provincia!),
                            if (usuario.direccion != null && usuario.direccion!.isNotEmpty)
                              _infoRow(Icons.home_outlined, usuario.direccion!),
                            if (usuario.nacionalidad != null && usuario.nacionalidad!.isNotEmpty)
                              _infoRow(Icons.flag_outlined, usuario.nacionalidad!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Indicador de página ───────────────────────
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _headerPage == i ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _headerPage == i
                            ? const Color(0xFFFC7E39)
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (usuario.descripcion != null && usuario.descripcion!.isNotEmpty)
                  Text(
                    usuario.descripcion!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: -0.31,
                    ),
                  ),

                const SizedBox(height: 16),

                if (usuario.instrumentos.isNotEmpty)
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: usuario.instrumentos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => _Badge(instrumento: usuario.instrumentos[i]),
                    ),
                  ),
              ],
            ),
          ),

          // ── Contenido scrollable ──────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFef365b), Color(0xFFfd8835)],
                          ),
                        ),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BandasAjenasPage(bandas: usuario.bandas),
                            ),
                          ),
                          icon: const Icon(Icons.groups, color: Colors.white, size: 20),
                          label: const Text(
                            'Ver sus bandas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text(
                            'Sus publicaciones',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: usuario.publicaciones.isEmpty
                      ? const Center(
                          child: Text(
                            'Este usuario no tiene publicaciones',
                            style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: usuario.publicaciones.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostCard(publicacion: usuario.publicaciones[i]),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: Colors.grey[800],
        child: const Icon(Icons.person, color: Colors.white54, size: 40),
      );
}

class _Badge extends StatelessWidget {
  final InstrumentoResponse instrumento;
  const _Badge({required this.instrumento});

  void _mostrarDetalle(BuildContext context) {
    Widget fila(IconData icono, String etiqueta, String valor) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: const Color(0xFFFC7E39), size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(etiqueta,
                        style: const TextStyle(
                            color: Color(0xFF9ca3af), fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(valor,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232120),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.music_note, color: Color(0xFFFC7E39), size: 22),
                const SizedBox(width: 10),
                Text(
                  instrumento.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12),
            const SizedBox(height: 12),
            if (instrumento.nivel != null)
              fila(Icons.bar_chart_rounded, 'Nivel', instrumento.nivel!),
            if (instrumento.experiencia != null)
              fila(Icons.access_time_rounded, 'Experiencia', '${instrumento.experiencia} años'),
            if (instrumento.generos != null && instrumento.generos!.isNotEmpty)
              fila(Icons.queue_music_rounded, 'Géneros', instrumento.generos!),
            if (instrumento.descripcion != null && instrumento.descripcion!.isNotEmpty)
              fila(Icons.notes_rounded, 'Descripción', instrumento.descripcion!),
            if (instrumento.nivel == null &&
                instrumento.experiencia == null &&
                (instrumento.generos == null || instrumento.generos!.isEmpty) &&
                (instrumento.descripcion == null || instrumento.descripcion!.isEmpty))
              const Text(
                'Sin información adicional',
                style: TextStyle(color: Color(0xFF9ca3af), fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _mostrarDetalle(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 2.5),
        decoration: BoxDecoration(
          color: const Color(0xFF2d2a28),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
        ),
        child: Center(
          child: Text(
            instrumento.nombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
