import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexoband_mobile/core/dto/register_request.dart';
import 'package:nexoband_mobile/core/service/register_service.dart';
import 'package:nexoband_mobile/features/login/ui/login_page_view.dart';
import 'package:nexoband_mobile/features/registro/bloc/registro_bloc.dart';
import 'package:nexoband_mobile/features/registro/bloc/registro_event.dart';
import 'package:nexoband_mobile/features/registro/bloc/registro_state.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  late RegistroBloc registerBloc;
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final provinciaController = TextEditingController();
  final nacionalidadController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    registerBloc = RegistroBloc(RegisterService());
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    provinciaController.dispose();
    nacionalidadController.dispose();
    registerBloc.close();
    super.dispose();
  }

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      final request = RegisterRequest(
        nombre: nombreController.text.trim(),
        apellidos: apellidosController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: passwordConfirmController.text.trim(),
        telefono: telefonoController.text.trim(),
        direccion: direccionController.text.trim(),
        provincia: provinciaController.text.trim(),
        nacionalidad: nacionalidadController.text.trim(),
      );
      registerBloc.add(RealizarRegistroEvent(request: request));
    }
  }

  // ── helpers de estética ──────────────────────────────────────────────────

  static const _gradientColors = [Color(0xFFF13B57), Color(0xFFFC7E39)];
  static const _darkBg = Color(0xFF232120);

  InputDecoration _inputDeco(String label, IconData icon) {
    const borderRadius = BorderRadius.all(Radius.circular(20));
    const borderSide = BorderSide(width: 2, color: Colors.white);
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFFFC7E39),
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: Icon(icon, color: Color(0xFFFC7E39)),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(width: 2, color: Color(0xFFF13B57)),
      ),
      errorStyle: const TextStyle(color: Color(0xFFF13B57)),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDeco(label, icon).copyWith(
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Color(0xFFFC7E39),
                ),
                onPressed: toggleObscure,
              )
            : null,
      ),
      validator: validator,
    );
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: registerBloc,
      child: BlocListener<RegistroBloc, RegistroState>(
        listener: (context, state) {
          if (state is RegistroSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPageView()),
            );
          } else if (state is RegistroFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: _darkBg,
          body: BlocBuilder<RegistroBloc, RegistroState>(
            builder: (context, state) {
              final isLoading = state is RegistroLoading;
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40,
                  bottom: 40,
                  left: 8,
                  right: 8,
                ),
                child: Column(
                  children: [
                    // ── Logo ──────────────────────────────────────────────
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: _gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.music_note, size: 48, color: Colors.white),
                          Text(
                            'NexoBand',
                            style: GoogleFonts.chicle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Formulario ────────────────────────────────────────
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          children: [
                            // Nombre
                            _buildField(
                              controller: nombreController,
                              label: 'Nombre',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
                            ),
                            const SizedBox(height: 20),

                            // Apellidos
                            _buildField(
                              controller: apellidosController,
                              label: 'Apellidos',
                              icon: Icons.badge_outlined,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'Los apellidos son requeridos' : null,
                            ),
                            const SizedBox(height: 20),

                            // Username
                            _buildField(
                              controller: usernameController,
                              label: 'Nombre de usuario',
                              icon: Icons.alternate_email,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'El username es requerido';
                                if (v.contains(' ')) return 'El username no puede tener espacios';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Email
                            _buildField(
                              controller: emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'El email es requerido';
                                final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!regex.hasMatch(v)) return 'Email no válido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Teléfono
                            _buildField(
                              controller: telefonoController,
                              label: 'Teléfono',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'El teléfono es requerido';
                                if (v.length > 15) return 'Máximo 15 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Dirección
                            _buildField(
                              controller: direccionController,
                              label: 'Dirección',
                              icon: Icons.home_outlined,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'La dirección es requerida' : null,
                            ),
                            const SizedBox(height: 20),

                            // Provincia
                            _buildField(
                              controller: provinciaController,
                              label: 'Provincia',
                              icon: Icons.location_city_outlined,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'La provincia es requerida' : null,
                            ),
                            const SizedBox(height: 20),

                            // Nacionalidad
                            _buildField(
                              controller: nacionalidadController,
                              label: 'Nacionalidad',
                              icon: Icons.flag_outlined,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'La nacionalidad es requerida' : null,
                            ),
                            const SizedBox(height: 20),

                            // Contraseña
                            _buildField(
                              controller: passwordController,
                              label: 'Contraseña',
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword,
                              toggleObscure: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'La contraseña es requerida';
                                if (v.length < 8) return 'Mínimo 8 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Confirmar contraseña
                            _buildField(
                              controller: passwordConfirmController,
                              label: 'Confirmar contraseña',
                              icon: Icons.lock_outline,
                              obscure: _obscureConfirm,
                              toggleObscure: () =>
                                  setState(() => _obscureConfirm = !_obscureConfirm),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                                if (v != passwordController.text) return 'Las contraseñas no coinciden';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ── Botón registrar ───────────────────────────────────
                    GestureDetector(
                      onTap: isLoading ? null : _registrar,
                      child: Container(
                        width: 330,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: _gradientColors),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Crear cuenta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Volver al login ───────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿Ya tienes cuenta?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 202, 201, 201),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: _gradientColors,
                            ).createShader(bounds),
                            child: const Text(
                              ' Inicia sesión',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
