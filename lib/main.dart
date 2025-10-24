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
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  final List<String> _sandwichOptions = ['Footlong', 'Six-inch'];
  int _selectedSandwichIndex = 0;
  String get _sandwichType => _sandwichOptions[_selectedSandwichIndex];

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  void _onSandwichSelected(Set<int> selection) {
    if (selection.isNotEmpty) {
      setState(() {
        _selectedSandwichIndex = selection.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              _sandwichType,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('Footlong'),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Six-inch'),
                  ),
                ],
                selected: {_selectedSandwichIndex},
                onSelectionChanged: _onSandwichSelected,
              ),
            ),
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
