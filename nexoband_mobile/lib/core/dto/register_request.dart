class RegisterRequest {
  final String nombre;
  final String apellidos;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String telefono;
  final String direccion;
  final String provincia;
  final String nacionalidad;

  RegisterRequest({
    required this.nombre,
    required this.apellidos,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.telefono,
    required this.direccion,
    required this.provincia,
    required this.nacionalidad,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellidos': apellidos,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation, // Laravel espera este campo para 'confirmed'
        'telefono': telefono,
        'direccion': direccion,
        'provincia': provincia,
        'nacionalidad': nacionalidad,
        'rol': 'user',
      };
}
