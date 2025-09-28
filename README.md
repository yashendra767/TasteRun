# TasteRun 🍔🍕🍣

**TasteRun** is a Flutter-based food delivery application that allows users to browse restaurants, place orders, and pay seamlessly. The app demonstrates best practices in Flutter development, including state management, navigation, and UI design.

---

## Table of Contents

- [Features](#features)
- [Screens](#screens)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Folder Structure](#folder-structure)
- [Usage](#usage)
- [Error Handling](#error-handling)
- [Future Enhancements](#future-enhancements)
- [License](#license)

---

## Features

- Browse a list of restaurants with ratings and cuisine types.
- View restaurant menus and add items to cart.
- Checkout and simulate payment using UPI, credit/debit cards, or cash on delivery.
- Real-time cart updates with Flutter Bloc state management.
- Architecture following SOLID principles.
- Order confirmation with unique order IDs.
- Aesthetic and responsive UI following Material Design principles.
- Error handling for network issues, invalid input, and empty cart scenarios.

---

## Screens

### 🍴 Restaurant Flow  
| Restaurant List | Menu Screen |
|-----------------|-------------|
| <img src="https://github.com/user-attachments/assets/91415e28-17be-4a30-bab1-5fed57c97196" alt="Restaurant List" width="250"/> | <img src="https://github.com/user-attachments/assets/6d754d4b-aad9-469e-8bd9-3a187971684a" alt="Menu Screen" width="250"/> |

---

### 🛒 Cart & Checkout  
| Cart Screen | Checkout Screen |
|-------------|-----------------|
| <img src="https://github.com/user-attachments/assets/aaabf5b8-1f80-4dff-a58b-ff82d39ed35f" alt="Cart Screen" width="250"/> | <img src="https://github.com/user-attachments/assets/f2ba32eb-d2ab-4191-896d-3dfc6c8e3acb" alt="Checkout Screen" width="250"/> |

---

### 💳 Payment Flow  
| Payment Screen | Order Confirmation |
|----------------|--------------------|
| <img src="https://github.com/user-attachments/assets/8eb9e1ee-3e0a-404a-9104-54cc5f6417a5" alt="Payment Screen" width="250"/> | <img src="https://github.com/user-attachments/assets/03e6194e-06ee-4521-8b33-425f66880669" alt="Order Confirmation Screen" width="250"/> |

---

### 📖 Order History  
| Order History (Demo) |
|----------------------|
| <img src="https://github.com/user-attachments/assets/6d38aaac-40be-4fd7-b59a-78a96acf4786" alt="Order History" width="250"/> |

---

## Architecture

- **State Management:** Flutter Bloc (Cubit) for cart management.
- **Dependency Injection:** `get_it` for repository management.
- **Navigation:** Flutter `Navigator` with clearly separated screens.
- **Error Handling:** Defensive programming on all user actions.
- **UI Design:** Material 3 guidelines with custom color schemes.

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0
- Dart >= 3.0
- Android Studio / VS Code
- Emulator or physical device

---

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd taste_run
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

---

## Dependencies

- `flutter_bloc` → State management
- `get_it` → Dependency injection
- `equatable` → Value equality for models
- `flutter_launcher_icons` → Launcher icon generation
- `intl` → Formatting of dates and numbers
- Other core Flutter packages as required

---

## Folder Structure

```
lib/
 ├── blocs/           # Bloc/Cubit files
 ├── core/            # Constants, errors, utils
 ├── data/            # Models and repositories
 ├── domain/          # Repository interfaces
 ├── screens/         # All UI screens
 │   ├── restaurant/
 │   ├── menu/
 │   ├── cart/
 │   ├── checkout/
 │   ├── payment/
 │   └── order_confirmation/
 ├── config/theme/          # Color schemes and themes
 └── main.dart        # Entry point
```

---

## Usage

- Open **TasteRun**.
- Browse restaurants and select one.
- Add menu items to the cart.
- Proceed to checkout.
- Choose a payment method in the **Payment Screen**.
- Confirm order and view **Order Confirmation**.
- Return to restaurant list to repeat orders.

---

## Error Handling

- **Empty Cart Check:** Users cannot proceed to payment with an empty cart.
- **Input Validation:** Payment screen validates:
    - UPI ID must contain `@`.
    - Card number must be 16 digits.
    - CVV must be 3 digits.
    - Expiry date must be in MM/YY format.
- **Network Errors:** Retry buttons are available if fetching restaurants fails.
- **Defensive Programming:** Screens check for null or unexpected values before rendering.

---

## Future Enhancements

- Integrate **real payment gateways**.
- Connect to a backend database for **persistent order history**.
- Scale up to real time data.
- Push notifications for order updates.
- Advanced search and filter options for restaurants and menus.
- Dark mode support.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


---

**TasteRun** aims to demonstrate clean architecture, efficient error handling, and polished UI/UX in Flutter for a food delivery application.

