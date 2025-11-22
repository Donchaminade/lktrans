# lktrans

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Clean Architecture scaffold

J'ai ajouté une structure de base pour suivre la "Clean Architecture" (core / domain / data / presentation) avec un exemple minimal de feature `auth`.

Fichiers ajoutés importants:

- `lib/injection.dart` : configuration GetIt (service locator).
- `lib/core/` : fichiers utilitaires (`usecase.dart`, `failure.dart`).
- `lib/features/auth/` : exemple complet (domain, data, presentation) pour la connexion.

Pour tester rapidement l'exemple :

1. Mettre à jour les dépendances :

```powershell
flutter pub get
```

2. Lancer l'application (la page d'accueil montre la page de login d'exemple) :

```powershell
flutter run
```

Prochaines étapes suggérées:

- Remplacer `AuthRemoteDataSource` par un client HTTP réel.
- Ajouter gestion des erreurs avec `Failure` ou `Either` (package `dartz`).
- Ajouter tests unitaires pour usecases et repository.
