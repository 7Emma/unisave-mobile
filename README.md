# UniSave - Frontend Mobile (Flutter)

Application mobile Flutter pour la gestion collaborative d'épargne en tontine.

## Description

UniSave est une application de tontine (épargne collective) permettant aux utilisateurs de :
- Créer et rejoindre des tontines
- Gérer leurs contributions mensuelles
- Tracker leurs épargnes personnelles
- Effectuer des retraits via plusieurs méthodes
- Consulter l'historique des transactions
- Recevoir des notifications

## Architecture

```
lib/
├── config/                 # Configuration de l'app
├── core/                   # Utilitaires et helpers
├── errors/                 # Gestion des erreurs
├── models/                 # Modèles de données
├── pages/                  # Pages principales
├── screens/                # Écrans de l'application
│   ├── auth/              # Authentification (login, register)
│   ├── home/              # Accueil et gestion des tontines
│   └── savings/           # Gestion des épargnes
├── services/               # Services API
├── theme/                  # Thème et styles
└── main.dart              # Point d'entrée
```

## Écrans Principaux

### 1. Authentification
- **LoginScreen**: Connexion utilisateur
- **RegisterScreen**: Création de compte

### 2. Accueil (HomeScreen)
Affiche :
- **Solde total en épargne** (en haut, prominemment)
- **Bouton Retirer** (avec 3 méthodes)
  - Virement bancaire
  - Mobile Money (MTN, Moov, Orange Money)
  - Code QR (retrait via agent)
- **Bouton Ajouter une épargne** (navigation vers AddSavingsScreen)
- **Liste des tontines** actives
  - Affiche le nom, nombre de membres, montant mensuel
  - Cliquable pour voir les détails

### 3. Détails Tontine (TontineDetailScreen)
- Informations détaillées de la tontine
- Membres participants
- Historique des contributions
- Bouton pour effectuer un dépôt

### 4. Épargnes (SavingsScreen)
- Liste des épargnes personnelles
- Montants par catégorie
- Historique des transactions

### 5. Ajouter une Épargne (AddSavingsScreen)
- Formulaire pour ajouter une épargne
- Champs:
  - Montant (requis)
  - Catégorie (Autre, Urgence, Projet, Investissement, Voyage)
- Résumé avant validation

### 6. Notifications (NotificationsScreen)
- Alertes et notifications
- Rappels de contributions

### 7. Profil (ProfileScreen)
- Informations utilisateur
- Paramètres du compte
- Déconnexion

## Services API

### TontineService
Appels API pour la gestion des tontines:
- `getUserTontines()` - Liste des tontines de l'utilisateur
- `getTontineDetails(id)` - Détails d'une tontine
- `addDeposit(tontineId, amount)` - Ajouter une contribution
- `getTotalBalance()` - Récupérer le solde total (TODO)

### SavingsService
Gestion des épargnes personnelles:
- `addSavings(amount, category)` - Ajouter une épargne (TODO)
- `getSavingsHistory()` - Historique des épargnes (TODO)
- `withdrawFunds(method, amount)` - Effectuer un retrait (TODO)

## Palette de Couleurs

```dart
const Color darkGreen = Color(0xFF0B6E4F);   // Vert principal
const Color gold = Color(0xFFF4C430);       // Doré/accentuation
const Color beige = Color(0xFFFAF3E0);      // Beige de fond
```

## Installation & Setup

### Prérequis
- Flutter 3.0+
- Dart 3.0+

### Installation
```bash
cd frontend
flutter pub get
flutter run
```

### Configuration
Modifiez `lib/config/` pour configurer les endpoints API et les paramètres.

## State Management
Actuellement en utilisant `setState`. 

À considérer pour le futur:
- Provider
- Riverpod
- GetX
- BLoC

## TODO / En cours

### À implémenter
- [ ] Intégration API complète pour `getTotalBalance()`
- [ ] Implémentation API `addSavings()`
- [ ] Service de retrait (virement, mobile money, QR)
- [ ] Gestion des erreurs API complète
- [ ] Pagination des listes
- [ ] Offline mode / caching

### À améliorer
- [ ] Migration vers un state management robuste
- [ ] Tests unitaires et d'intégration
- [ ] Animations et transitions
- [ ] Accessibilité (a11y)
- [ ] Localisation (français/anglais)

## Structure des Modèles de Données

### User
```dart
{
  _id: String,
  firstName: String,
  lastName: String,
  email: String,
  phone: String,
  createdAt: DateTime
}
```

### Tontine
```dart
{
  _id: String,
  name: String,
  description: String,
  monthlyAmount: double,
  members: [User],
  owner: User,
  status: String,  // 'active', 'completed', 'paused'
  createdAt: DateTime
}
```

### Savings
```dart
{
  _id: String,
  userId: String,
  amount: double,
  category: String,
  transactionDate: DateTime,
  description: String
}
```

## Dépendances Principales

```yaml
flutter:
  sdk: flutter

http: ^1.1.0           # Requêtes HTTP
shared_preferences:    # Stockage local
```

Voir `pubspec.yaml` pour la liste complète.

## Tests

Pour lancer les tests:
```bash
flutter test
```

## Build & Déploiement

### Android
```bash
flutter build apk
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

## Conventions de Code

- Noms en camelCase pour les variables et méthodes
- Noms en PascalCase pour les classes et widgets
- Préfixe `_` pour les méthodes/widgets privés
- Commentaires en français pour le code métier
- Commentaires en anglais pour la documentation technique

## Troubleshooting

### Erreurs de build
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Problèmes de connexion API
Vérifier que le backend tourne sur le bon port et que les CORS sont configurés.

## Support & Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- Backend API docs: voir `backend/README.md`

## Licence

Projet UniSave - Tous droits réservés
