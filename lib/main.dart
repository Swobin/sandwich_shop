import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

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
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();
  final PricingRepository _pricingRepository = PricingRepository();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  // NEW: store the latest user-facing confirmation message
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      setState(() {
        _cart.add(sandwich, _quantity);

        String sizeText = _isFootlong ? 'footlong' : 'six-inch';
        _confirmationMessage =
            'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';
      });
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich = Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final int itemsCount = _cart.totalQuantity;
    final double total = _cart.totalPriceWithRepository(_pricingRepository);
    final String totalDisplay = _pricingRepository.formatPrice(total);

    return Scaffold(
      appBar: AppBar(
        // make the bar taller so the logo can be bigger
        toolbarHeight: 72,
        // give the leading area more horizontal space
        leadingWidth: 72,
        leading: SizedBox(
          width: 64,
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // add top padding so the image is always clear of the app bar
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), // extra spacing before image
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not found',
                        style: normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$_quantity',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                key: const Key('add_to_cart_button'),
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 12),
              // NEW: visible confirmation message for UI and tests
              if (_confirmationMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _confirmationMessage,
                    key: const Key('confirmation_message'),
                    style: normalText,
                  ),
                ),
              const SizedBox(height: 12),
              // NEW: persistent cart summary (always visible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Items: $itemsCount', key: const Key('cart_item_count'), style: normalText),
                    Row(
                      children: [
                        Text('Total: $totalDisplay', key: const Key('cart_total_price'), style: normalText),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          key: const Key('cart_clear_button'),
                          onPressed: () async {
                            if (_cart.items.isEmpty) return;
                            final bool? confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Clear cart?'),
                                content: const Text('This will remove all items from your cart.'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear')),
                                ],
                              ),
                            );
                            if (confirmed != true) return;

                            // backup current items to allow undo
                            final backup = _cart.items
                                .map((it) => CartItem(sandwich: it.sandwich, quantity: it.quantity))
                                .toList();

                            setState(() {
                              _cart.clear();
                              _confirmationMessage = 'Cleared cart';
                            });

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Cart cleared'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      _cart.items.clear();
                                      _cart.items.addAll(backup);
                                      _confirmationMessage = 'Restored cart';
                                    });
                                  },
                                ),
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Cart items list with quantity controls (Subtask A)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Cart Items', style: heading2),
                    const SizedBox(height: 8),
                    if (_cart.items.isEmpty)
                      const Text('Your cart is empty', key: Key('cart_empty_text'), style: normalText)
                    else
                      ..._cart.items.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final cartItem = entry.value;
                        return Padding(
                          key: Key('cart_item_$index'),
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cartItem.sandwich.name, style: normalText),
                                    Text('Bread: ${cartItem.sandwich.breadType.name}', style: normalText),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    key: Key('cart_dec_$index'),
                                    onPressed: () {
                                      setState(() {
                                        _cart.remove(cartItem.sandwich, 1);
                                      });
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '${cartItem.quantity}',
                                      key: Key('cart_qty_$index'),
                                      style: normalText,
                                    ),
                                  ),
                                  IconButton(
                                    key: Key('cart_inc_$index'),
                                    onPressed: () {
                                      setState(() {
                                        _cart.add(cartItem.sandwich, 1);
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  // EDIT button — opens modal to change type/size/bread/quantity
                                  IconButton(
                                    key: Key('cart_edit_button_$index'),
                                    onPressed: () {
                                      // show modal bottom sheet with controls
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          SandwichType editedType = cartItem.sandwich.type;
                                          bool editedIsFootlong = cartItem.sandwich.isFootlong;
                                          BreadType editedBread = cartItem.sandwich.breadType;
                                          int editedQuantity = cartItem.quantity;

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom,
                                            ),
                                            child: StatefulBuilder(
                                              builder: (context, setModalState) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      const Text('Edit item', style: heading2),
                                                      const SizedBox(height: 12),
                                                      // Sandwich type dropdown
                                                      DropdownButton<SandwichType>(
                                                        value: editedType,
                                                        isExpanded: true,
                                                        items: SandwichType.values.map((t) {
                                                          final label = Sandwich(
                                                                  type: t, isFootlong: true, breadType: BreadType.white)
                                                              .name;
                                                          return DropdownMenuItem<SandwichType>(
                                                            value: t,
                                                            child: Text(label),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          if (val != null) {
                                                            setModalState(() => editedType = val);
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Size switch
                                                      Row(
                                                        children: [
                                                          const Text('Six-inch'),
                                                          Switch(
                                                            value: editedIsFootlong,
                                                            onChanged: (v) => setModalState(() => editedIsFootlong = v),
                                                          ),
                                                          const Text('Footlong'),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Bread dropdown
                                                      DropdownButton<BreadType>(
                                                        value: editedBread,
                                                        isExpanded: true,
                                                        items: BreadType.values.map((b) {
                                                          return DropdownMenuItem<BreadType>(
                                                            value: b,
                                                            child: Text(b.name),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          if (val != null) setModalState(() => editedBread = val);
                                                        },
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Quantity controls
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          IconButton(
                                                            onPressed: editedQuantity > 0
                                                                ? () => setModalState(() => editedQuantity--)
                                                                : null,
                                                            icon: const Icon(Icons.remove),
                                                          ),
                                                          Text('$editedQuantity', style: normalText),
                                                          IconButton(
                                                            onPressed: () => setModalState(() => editedQuantity++),
                                                            icon: const Icon(Icons.add),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(),
                                                            child: const Text('Cancel'),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                              // apply changes: remove original entry and add edited sandwich
                                                              final newSandwich = Sandwich(
                                                                type: editedType,
                                                                isFootlong: editedIsFootlong,
                                                                breadType: editedBread,
                                                              );
                                                              setState(() {
                                                                // remove original item entirely
                                                                _cart.remove(cartItem.sandwich, cartItem.quantity);
                                                                // add edited item (will merge if identical exists)
                                                                if (editedQuantity > 0) {
                                                                  _cart.add(newSandwich, editedQuantity);
                                                                }
                                                                // update confirmation message
                                                                _confirmationMessage =
                                                                    'Updated $editedQuantity ${editedIsFootlong ? "footlong" : "six-inch"} ${newSandwich.name} on ${editedBread.name} bread';
                                                              });
                                                            },
                                                            child: const Text('Save'),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  // DELETE button with undo via SnackBar
                                  IconButton(
                                    key: Key('cart_remove_button_$index'),
                                    onPressed: () {
                                      final removedSandwich = cartItem.sandwich;
                                      final removedQuantity = cartItem.quantity;
                                      setState(() {
                                        // remove entire item
                                        _cart.remove(removedSandwich, removedQuantity);
                                      });
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Removed $removedQuantity ${removedSandwich.name}'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              setState(() {
                                                _cart.add(removedSandwich, removedQuantity);
                                              });
                                            },
                                          ),
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
