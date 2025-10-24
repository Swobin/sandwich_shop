import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OrderItemDisplay(3, 'BLT'),
                  OrderItemDisplay(5, 'Club'),
                  OrderItemDisplay(2, 'Veggie'),
                ],
              ),
            ),
            // Fixed Row with StyledButton
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  text: 'Add',
                  onPressed: _increaseQuantity,
                  backgroundColor: Colors.green,
                  enabled: _quantity < widget.maxQuantity,
                ),
                const SizedBox(width: 16.0),
                StyledButton(
                  text: 'Remove',
                  onPressed: _decreaseQuantity,
                  backgroundColor: Colors.red,
                  enabled: _quantity > 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final bool enabled;

  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final bool enabled;

  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
} 
class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String sandwichType;

  const OrderItemDisplay(this.quantity, this.sandwichType, {super.key}); // Expects exactly 2 positional args

  @override
  Widget build(BuildContext context) {
    final String suffix = quantity == 1 ? ' sandwich' : ' sandwiches';
    return Text(
      '$quantity $sandwichType$suffix: ${'🥪' * quantity}',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
