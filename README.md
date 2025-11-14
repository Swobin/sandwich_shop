# Sandwich Shop

A Flutter application for managing sandwich orders with customizable options including bread type, sandwich size, and special notes.

## Project Description

Sandwich Shop is a simple yet functional order management app that allows users to:
- Select between six-inch and footlong sandwich sizes
- Choose from multiple bread types (white, wheat, honey)
- Add quantity controls with increment/decrement buttons
- Add special notes/instructions for their order
- View their complete order summary

## Project Structure

```
lib/
├── main.dart                          # Main app entry point and screens
├── app_styles.dart                    # Global text styles and constants
├── views/
│   └── app_styles.dart               # Styling definitions
├── repositories/
│   └── order_repository.dart         # Business logic for order management
└── view_models/

test/
├── repositories/
│   └── order_repository_test.dart    # Unit tests for OrderRepository
└── widget_test.dart                   # Widget tests
```

## Features

- **Sandwich Size Selection**: Toggle between six-inch and footlong options
- **Bread Type Selection**: Dropdown menu to choose bread type
- **Quantity Management**: Add/remove sandwiches with visual feedback
- **Special Notes**: Add custom instructions or notes to orders
- **Order Display**: Real-time display of current order details
- **Input Validation**: Prevents invalid operations (e.g., negative quantities)

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd sandwich_shop
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

Or run without debugging:
```bash
flutter run --no-debug
```

## Usage

1. **Launch the app** - You'll see the Sandwich Counter screen
2. **Select sandwich size** - Use the switch to toggle between six-inch and footlong
3. **Choose bread type** - Select from the dropdown menu
4. **Add notes** - Type any special instructions in the text field
5. **Manage quantity** - Click "Add" to increase or "Remove" to decrease the order quantity
6. **View order** - The display shows your current order with emoji sandwiches

## Testing

Run unit tests:
```bash
flutter test test/repositories/order_repository_test.dart
```

Run all tests:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## Known Issues and Limitations

- Maximum order quantity is currently hardcoded to 10
- No order persistence (orders are lost when app is closed)
- No backend integration for order submission
- UI is optimized for mobile devices
- No multi-language support

## Architecture

The app follows a simple layered architecture:

- **UI Layer** (`main.dart`): Flutter widgets and screens
- **Repository Layer** (`order_repository.dart`): Business logic and state management
- **Styles Layer** (`app_styles.dart`): Centralized styling

## Future Enhancements

- Add order persistence with local storage
- Implement backend API integration
- Add order history
- Support for additional toppings and customizations
- Order summary and checkout screen
- Dark mode support

## Contact

For questions or feedback, contact the development team or open an issue in the repository.

## License

This project is licensed under the MIT License - see LICENSE file for details.
