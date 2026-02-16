import 'package:flutter/material.dart';

class EventoListView extends StatefulWidget {
  const EventoListView({super.key});

  @override
  State<EventoListView> createState() => _EventoListViewState();
}

class _EventoListViewState extends State<EventoListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        title: const Text(
          'Eventos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Column(
        children: [
          // Mapa simulado
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // Cuadrícula simple para simular mapa
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GridMapPainter(),
                  ),
                ),
                // Marcadores
                ...[
                  const Offset(60, 40),
                  const Offset(140, 120),
                  const Offset(220, 60),
                ].map((offset) => Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: _MapMarker(),
                )),
                // Botones de zoom
                Positioned(
                  right: 12,
                  top: 24,
                  child: Column(
                    children: [
                      _MapIconButton(icon: Icons.add),
                      const SizedBox(height: 12),
                      _MapIconButton(icon: Icons.search),
                    ],
                  ),
                ),
                // Botón de eventos próximos
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      '3 eventos próximos',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de eventos
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              children: [
                _EventoCard(onTap: () => _showEventoDetails(context)),
                const SizedBox(height: 16),
                // Imagen de evento (simulada)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  void _showEventoDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF232323),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detalles del evento',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Showcase acústico',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=80&q=80'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Organizado por',
                            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                          ),
                          Text(
                            'The Electric Souls',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _IconGradientBox(icon: Icons.calendar_today),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Fecha y hora', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                          Text('Jueves, 30 de enero de 2025\n19:00', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _IconGradientBox(icon: Icons.location_on),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Ubicación', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                          Text('Café Blue Note', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Descripción', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text(
                    'Versiones acústicas de nuestros temas más populares',
                    style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: null,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        // Degradado
                        shadowColor: Colors.transparent,
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) => null),
                      ),
                      icon: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                          ).createShader(bounds);
                        },
                        child: const Icon(Icons.group, color: Colors.white),
                      ),
                      label: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                          ).createShader(bounds);
                        },
                        child: const Text('Confirmar asistencia', style: TextStyle(color: Colors.white)),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Widgets auxiliares ---

class _GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF444444)
      ..strokeWidth = 3;
    for (double i = 0; i < size.width; i += size.width / 4) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += size.height / 4) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.place, color: Colors.white, size: 24),
      ),
    );
  }
}

class _MapIconButton extends StatelessWidget {
  final IconData icon;
  const _MapIconButton({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final VoidCallback onTap;
  const _EventoCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('30', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                      Text('ENE', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Showcase acústico',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=80&q=80'),
                        ),
                        SizedBox(width: 6),
                        Text('The Electric Souls', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                        SizedBox(width: 4),
                        Text('Café Blue Note', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.redAccent, size: 16),
                        SizedBox(width: 4),
                        Text('19:00', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Versiones acústicas de nuestros temas más populares',
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF444444)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: null,
                elevation: 0,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shadowColor: Colors.transparent,
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) => null),
              ),
              onPressed: onTap,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                  ).createShader(bounds);
                },
                child: const Text('Ver detalles', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconGradientBox extends StatelessWidget {
  final IconData icon;
  const _IconGradientBox({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
        ),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF232323),
      selectedItemColor: const Color(0xFFFFA726),
      unselectedItemColor: const Color(0xFFB0B0B0),
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Mensajes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      onTap: (index) {},
    );
  }
}
