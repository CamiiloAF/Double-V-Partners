# Testing Guide

Este proyecto incluye unit tests completos para todos los componentes de la carpeta `features`.

## Estructura de Tests

```
test/
├── features/
│   ├── auth/
│   │   ├── data/repositories/           # Tests para repositories
│   │   ├── domain/use_cases/           # Tests para casos de uso
│   │   └── presentation/cubit/         # Tests para cubits
│   └── profile/
│       ├── data/repository/            # Tests para repositories
│       ├── domain/use_case/           # Tests para casos de uso
│       └── presentation/cubit/        # Tests para cubits
├── helpers/
│   └── test_helpers.dart              # Utilidades para tests
└── test_mocks.dart                    # Configuración de mocks
```

## Comandos de Testing

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Generar mocks (primera vez o cuando cambien las interfaces)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Ejecutar todos los tests

```bash
flutter test
```

### 4. Ejecutar tests con coverage

```bash
flutter test --coverage
```

### 5. Ejecutar tests específicos

```bash
# Tests de auth
flutter test test/features/auth/

# Tests de profile
flutter test test/features/profile/

# Test específico
flutter test test/features/auth/presentation/cubit/login_cubit_test.dart
```

## Cobertura de Tests

### Auth Module

- ✅ LoginRepositoryImpl
- ✅ SignUpRepositoryImpl
- ✅ LoginWithEmailAndPasswordUseCase
- ✅ SignUpUseCase
- ✅ LoginCubit
- ✅ SignUpCubit
- ✅ CurrentUserCubit

### Profile Module

- ✅ ProfileRepositoryImpl
- ✅ LogoutUseCase
- ✅ ProfileCubit

## Tecnologías de Testing

- **flutter_test**: Framework de testing de Flutter
- **bloc_test**: Testing específico para BLoC/Cubit
- **mockito**: Mocking de dependencias
- **build_runner**: Generación de mocks automática
- **fake_async**: Testing de código asíncrono

## Helpers Disponibles

El archivo `test_helpers.dart` incluye métodos para crear objetos de prueba:

```dart
// Crear usuario de prueba
final user = TestHelpers.createUserModel();

// Crear modelo de sign up
final signUp = TestHelpers.createSignUpModel();

// Crear dirección
final address = TestHelpers.createAddress();
```

## Patrones de Testing

### Repository Tests

- Mockean Firebase Auth y Firestore
- Verifican casos de éxito y error
- Validan transformación de datos

### Use Case Tests

- Mockean repositories
- Verifican lógica de negocio
- Prueban manejo de errores

### Cubit Tests

- Usan `bloc_test` para verificar emisión de estados
- Mockean use cases
- Verifican flujos completos de estados
