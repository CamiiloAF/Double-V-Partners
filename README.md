# Double V Partners Tech

Una aplicación Flutter para gestión de usuarios con registro, autenticación y manejo de direcciones
múltiples.

## 📱 Características

- **Autenticación completa**: Registro, login y logout con Firebase Auth
- **Gestión de usuarios**: Información personal con validación de mayoría de edad
- **Direcciones múltiples**: Los usuarios pueden agregar y gestionar múltiples direcciones
- **Arquitectura limpia**: Implementación con BLoC/Cubit, Clean Architecture y principios SOLID
- **Testing completo**: Unit tests para repositories, use cases y cubits
- **UI/UX moderna**: Diseño elegante con paleta de colores personalizada

## 🛠️ Requisitos Técnicos

### Flutter

- **Versión mínima**: Flutter 3.8.1
- **Dart SDK**: ^3.8.1

### Plataformas Soportadas

- **iOS**: 15.0+
- **Android**: API 21+ (Android 5.0)

### Herramientas Requeridas

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Xcode (para iOS)
- Firebase CLI (para configuración)

## 🏗️ Arquitectura

### Patrón de Arquitectura

- **Clean Architecture** con separación por capas
- **Feature-first** organization
- **Dependency Injection** con GetIt e Injectable

### Gestión de Estado

- **BLoC/Cubit** para manejo de estados
- **Reactive Forms** para validación de formularios
- **Go Router** para navegación declarativa

### Estructura del Proyecto

```
lib/
├── core/                 # Funcionalidades compartidas
│   ├── di/              # Dependency Injection
│   ├── domain/          # Entidades y modelos base
│   ├── exceptions/      # Manejo de errores
│   ├── firestore/       # Integración con Firestore
│   └── services/        # Servicios compartidos
├── features/            # Características por módulos
│   ├── auth/            # Autenticación
│   │   ├── data/        # Repositories y data sources
│   │   ├── domain/      # Use cases y entities
│   │   └── presentation/# UI y Cubits
│   ├── profile/         # Gestión de perfil
│   └── splash/          # Pantalla inicial
├── shared/              # Componentes reutilizables
│   ├── presentation/    # Formularios compartidos
│   ├── router/          # Configuración de rutas
│   ├── theme/           # Tema y colores
│   └── widgets/         # Widgets personalizados
└── main.dart
```

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone <repository-url>
cd double_v_partners_tech
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Generar Código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Ejecutar la Aplicación

```bash
flutter run
```

## 📦 Dependencias Principales

### Core Dependencies

- **flutter_bloc** (9.1.1) - Gestión de estado
- **get_it** (8.0.3) - Dependency injection
- **injectable** (2.5.0) - Code generation para DI
- **go_router** (16.0.0) - Navegación declarativa
- **reactive_forms** (18.1.1) - Formularios reactivos

### Firebase

- **firebase_core** (^4.1.1) - Core de Firebase
- **firebase_auth** (^6.1.0) - Autenticación
- **cloud_firestore** (^6.0.2) - Base de datos NoSQL

### Utilidades

- **dartz** (0.10.1) - Functional programming (Either)
- **freezed** (3.0.6) - Code generation para modelos
- **intl** (^0.20.2) - Internacionalización

### Testing

- **mockito** (^5.4.4) - Mocking para tests
- **bloc_test** (^10.0.0) - Testing para BLoC
- **fake_async** (^1.3.1) - Testing asíncrono

## 🧪 Testing

### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Tests con coverage
flutter test --coverage

# Tests específicos
flutter test test/features/auth/
```

### Cobertura de Tests

- ✅ Unit tests para todos los repositories
- ✅ Unit tests para todos los use cases
- ✅ Unit tests para todos los cubits
- ✅ Mocking de Firebase Auth y Firestore

## 🎨 Tema y Diseño

### Paleta de Colores

- **Primary**: #2563EB (Azul)
- **Secondary**: #1E40AF (Azul oscuro)
- **Accent**: #10B981 (Verde)
- **Error**: #EF4444 (Rojo)
- **Surface**: #FFFFFF (Blanco)
- **Background**: #F9FAFB (Gris claro)

### Componentes UI

- Formularios reactivos con validación
- Botones personalizados con loading states
- Diálogos de confirmación elegantes
- Inputs con iconos y validación visual

## 📱 Pantallas

1. **Splash Screen** - Verificación de sesión automática
2. **Login** - Autenticación con email y contraseña
3. **Registro** - Formulario de información personal
4. **Direcciones** - Gestión de múltiples direcciones
5. **Perfil** - Visualización y edición de datos

## 🔧 Scripts Útiles

### Generar Código

```bash
# Generar mocks para testing
dart run build_runner build --delete-conflicting-outputs

# Watch mode para desarrollo
dart run build_runner watch
```

### Linting y Formateo

```bash
# Analizar código
flutter analyze

# Formatear código
dart format .
```

## 🌟 Características Técnicas Destacadas

### Validaciones

- **Mayoría de edad**: Validación precisa considerando años bisiestos
- **Formularios reactivos**: Validación en tiempo real
- **Manejo de errores**: Mensajes localizados en español

### Firebase Integration

- **Auth**: Login/registro con email y contraseña
- **Firestore**: Almacenamiento de usuarios y direcciones
- **Security**: Reglas de seguridad implementadas

### Clean Architecture

- **Separation of Concerns**: Cada capa tiene responsabilidades específicas
- **Testability**: Fácil testing gracias a la inversión de dependencias
- **Maintainability**: Código organizado y escalable

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es una prueba técnica para Double V Partners.

## 📞 Soporte

Para preguntas o soporte, contacta al equipo de desarrollo.

---

**Desarrollado con ❤️ usando Flutter**
