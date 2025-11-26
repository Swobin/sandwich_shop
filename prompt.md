You are an expert Flutter developer LLM. I have a sandwich shop app with two screens:
- OrderScreen: users select sandwich type/size/bread and add items to a Cart.
- CartScreen: shows cart items and total price.

Project facts:
- Sandwich model exists (type, isFootlong, breadType, image, name).
- Cart class holds CartItem(sandwich, quantity) and exposes add/remove/setQuantity/totalQuantity/etc.
- PricingRepository provides pricing logic (e.g., totalPrice(quantity:, isFootlong:) and formatPrice()).
- Use only built-in Flutter widgets (no third-party packages).
- Update UI and keep all state/local models coherent; update totals via PricingRepository.

Task: propose and implement user-facing cart modification features. For each feature below provide:
1) Short description (user story).
2) Exact UI elements to add (widget types and where).
3) What should happen in state (Cart methods called, PricingRepository used).
4) Edge cases and validations.
5) Accessibility and UX notes (keyboard, semantics, touch targets).
6) Minimal code snippet showing how to implement it (Flutter; use existing Cart, Sandwich, PricingRepository APIs).
7) Unit/widget test ideas and one concrete test case example.

Features to cover:
- Change quantity (increment/decrement buttons and direct entry).
- Remove item (delete button and confirm/undo).
- Edit item options (open an edit dialog or inline editor to change size/bread/type and merge items).
- Clear cart (remove all).
- Persistent summary updates (items count + total price) after every change.

Constraints / expectations:
- Keep UI simple and minimal — no new pages required for editing (use dialogs, bottom sheet, or inline controls).
- Always recalc and display total using PricingRepository (do not hardcode prices).
- Ensure Cart merges identical sandwiches (same type/size/bread) when editing results in duplicates.
- Provide clear user feedback (confirmation message and update persistent cart summary).
- Provide testable keys for widgets (e.g., Key('cart_item_0'), Key('cart_total_price'), Key('cart_item_count'), Key('cart_remove_button_0')).

Example micro-spec for "Change quantity" (format you must follow for every feature):
- User story: "As a customer I want to change the quantity of an item in my cart so I can order more or fewer sandwiches."
- UI: Row per cart item contains: Text(name), Text(bread), IconButton(Icons.remove) key='cart_dec_{index}', Text(quantity) key='cart_qty_{index}', IconButton(Icons.add) key='cart_inc_{index}'.
- State change: tapping + calls cart.add(item, 1) or cart.setQuantity(...). tapping - calls cart.remove(item,1) or setQuantity with max(0,...). After change call setState and recompute total via pricingRepository.totalPrice(...).
- Edge cases: quantity cannot go below 0; if quantity becomes 0 remove item from cart; disable - when quantity==0; validate direct entry numeric only and clamp to a reasonable max (e.g., 99).
- Accessibility: provide semantic labels: "Increase quantity for Chicken Teriyaki", "Decrease quantity for ..." and 48x48 touch targets.
- Test example: widget test pumps CartScreen with initial one item quantity=1; tap increment button; expect displayed quantity '2' and cart_total_price updated via PricingRepository mock/stub.

Deliverable request:
- Provide the full prompt above implemented for every feature in the Features list.
- Include concrete Flutter code snippets for UI + state wiring (no full file replacements required, just the widget snippets and small helper functions).
- Include at least one complete widget test code snippet that can be added to test/widgets/cart_screen_test.dart verifying quantity change updates both quantity and displayed total price.
- Keep each feature section short (max ~10 lines description + 10-20 lines code sample).

Return only the specification and code snippets in plain text suitable to paste into an LLM/chatbox or a code editor.