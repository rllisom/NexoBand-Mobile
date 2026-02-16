import 'package:flutter/material.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({super.key});

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'MI ACTIVIDAD',
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildCard(
                context,
                icon: Icons.group,
                title: 'Ver seguidores',
                subtitle: 'Personas que te siguen',
                onTap: () => Navigator.pushNamed(context, '/seguidores'),
              ),
              _buildCard(
                context,
                icon: Icons.person_add,
                title: 'Ver seguidos',
                subtitle: 'Personas que sigues',
                onTap: () => Navigator.pushNamed(context, '/seguidos'),
              ),
              _buildCard(
                context,
                icon: Icons.favorite_border,
                title: 'Ver me gusta',
                subtitle: 'Publicaciones que te gustaron',
                onTap: () => Navigator.pushNamed(context, '/me-gusta'),
              ),
              const SizedBox(height: 24),
              const Text(
                'CUENTA',
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildCard(
                context,
                icon: Icons.logout,
                title: 'Cerrar sesión',
                subtitle: 'Salir de tu cuenta',
                titleColor: Colors.redAccent,
                onTap: () => Navigator.pushNamed(context, '/logout'),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: const [
                    Text(
                      'NexoBand v1.0.0',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '© 2026 NexoBand. Todos los derechos reservados.',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3A1A1A),
          child: Icon(icon, color: Colors.redAccent),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFB0B0B0), size: 18),
        onTap: onTap,
      ),
    );
  }
}