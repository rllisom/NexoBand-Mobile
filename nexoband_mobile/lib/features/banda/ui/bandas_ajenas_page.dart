import 'package:flutter/material.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/banda/ui/widget/banda_card.dart';

class BandasAjenasPage extends StatefulWidget {
  final List<BandaEnUsuarioResponse> bandas;

  const BandasAjenasPage({super.key, required this.bandas});

  @override
  State<BandasAjenasPage> createState() => _BandasAjenasPageState();
}

class _BandasAjenasPageState extends State<BandasAjenasPage> {
  late List<BandaEnUsuarioResponse> _bandas;

  @override
  void initState() {
    super.initState();
    _bandas = widget.bandas;
  }

  Future<void> _recargar() async {
    final userId = await GuardarToken.getUsuarioId();
    final user = await PerfilService().getUsuario(userId);
    if (mounted) setState(() => _bandas = user.bandas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        elevation: 0,
        title: const Text(
          'Sus bandas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _bandas.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) => RefreshIndicator(
                color: const Color(0xFFFC7E39),
                backgroundColor: const Color(0xFF232120),
                onRefresh: _recargar,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: const Center(
                      child: Text(
                        'El usuario no tiene bandas aún.',
                        style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFFFC7E39),
              backgroundColor: const Color(0xFF232120),
              onRefresh: _recargar,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: _bandas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final banda = _bandas[index];
                  return BandaCard(banda: banda);
                },
              ),
            ),
    );
  }
}
