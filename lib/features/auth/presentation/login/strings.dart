abstract class LoginStrings {
  static const String welcome = 'Bienvenido';
  static const String login = 'Ingreso';
  static const String email = 'Email';
  static const String password = 'Contraseña';
  static const String loginButton = 'Iniciar sesión';

  // Validation messages
  static const String requiredField = 'Este campo es obligatorio';
  static const String invalidEmail = 'Email inválido';

  static String minLengthError(String minLength) =>
      'Al menos $minLength caracteres son necesarios';
}
