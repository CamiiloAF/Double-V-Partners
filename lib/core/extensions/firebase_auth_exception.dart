import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  String get errorMessage {
    switch (code) {
      case 'invalid-email':
        return 'La dirección de correo electrónico no es válida.';
      case 'user-disabled':
      case 'user-not-found':
      case 'wrong-password':
        return 'Credenciales incorrectas. Por favor intenta nuevamente o restablece tu contraseña.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso. Por favor usa un correo diferente o inicia sesión.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Por favor contacta a soporte para obtener ayuda.';
      case 'weak-password':
        return 'La contraseña es muy débil. Por favor elige una contraseña más segura.';
      case 'network-request-failed':
        return 'Error de red. Por favor verifica tu conexión a internet e intenta nuevamente.';
      case 'too-many-requests':
        return 'Demasiadas solicitudes. Por favor espera un momento e intenta nuevamente.';
      case 'requires-recent-login':
        return 'Por favor vuelve a autenticarte e intenta nuevamente.';
      default:
        return 'Ocurrió un error desconocido. Por favor intenta nuevamente más tarde.';
    }
  }
}
