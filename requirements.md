Cart modification — Requirements
1. Feature overview
Allow users to modify items in their cart from the existing UI (no new pages). Modifications include changing quantity, removing items, editing item options (type/size/bread) and clearing the cart. All UI updates must recalculate and display totals via the existing PricingRepository. Provide simple, testable UI controls and feedback (confirmation message + persistent summary).

2. Purpose
Make the cart interactive so users can adjust their order before checkout. Improve UX by showing immediate visual feedback, keeping pricing authoritative (PricingRepository), and making the UI testable and accessible.

3. Scope
In scope

Increment/decrement quantity per cart item (buttons + optional direct entry).
Remove single items (immediate remove with undo affordance).
Edit item options (inline dialog/bottom sheet) and merge identical items when edits produce duplicates.
Clear cart (single action to remove all items).
Persistent cart summary (item count and total price) visible on OrderScreen; updates instantly.
Widget tests and unit tests verifying behavior.
Out of scope

New navigation flows or full cart page redesign.
Third-party packages.
Persistent storage across app restarts.
4. User stories & acceptance criteria (by subtask)
Subtask A — Change quantity
User story: As a customer I want to change the quantity of an item in my cart so I can order more or fewer sandwiches.
UI: Each cart item row includes:
IconButton(Icons.remove) key cart_dec_{index}
Text(quantity) key cart_qty_{index}
IconButton(Icons.add) key cart_inc_{index}
(Optional) TextField for direct numeric entry key cart_qty_input_{index}
State changes:
calls cart.add(sandwich, 1) or cart.setQuantity(...).
− calls cart.remove(sandwich, 1) or setQuantity(max(0, current - 1)).
After change call setState and recalc total with PricingRepository.totalPrice(...)
Acceptance criteria:
Tapping + increments displayed quantity and updates cart total.
Tapping − decrements quantity; when quantity reaches 0 the item is removed.
Direct numeric entry accepts only digits and clamps to [0..99]; invalid input is rejected and original quantity retained.
Buttons disabled when their action is not valid (e.g., − disabled when quantity == 0).
Tests:
Widget test: start with quantity=1, tap + => expect quantity '2' and total updated to pricingRepository.totalPrice(...).
Widget test: decrement to 0 => item row gone, item count decreased.
Subtask B — Remove item (delete + undo)
User story: As a customer I want to remove an item from my cart quickly and recover it if I removed it by mistake.
UI:
Remove IconButton(Icons.delete) key cart_remove_button_{index} on each row.
Show a short Snackbar with "Removed X — Undo" after removal (Undo restores previous quantity).
State changes:
Remove action calls cart.remove(sandwich, currentQuantity) or cart.setQuantity(..., 0).
Snackbar Undo calls cart.setQuantity(sandwich, previousQuantity).
Recompute total via PricingRepository after both actions.
Acceptance criteria:
Pressing delete removes item immediately from UI and updates summary/total.
Snackbar appears for N seconds with Undo; tapping Undo restores item quantity and total.
If Undo not tapped, removal persists.
Tests:
Widget test: tap delete, expect row absent and total updated; tap Undo on snackbar, expect row present and total restored.
Subtask C — Edit item options (type/size/bread)
User story: As a customer I want to edit an item in my cart (change size/bread/type) so I can correct choices without re-adding from scratch.
UI:
Edit IconButton(Icons.edit) key cart_edit_button_{index} opens a dialog or bottom sheet containing the same controls used on OrderScreen (SandwichType dropdown, size switch, BreadType dropdown, quantity control).
State changes:
On save, build a new Sandwich with chosen options.
If edited result matches an existing cart entry, merge: increase that entry’s quantity by edited quantity and remove the original entry.
Otherwise replace the original entry’s sandwich and quantity.
Recompute totals via PricingRepository.
Acceptance criteria:
Edit dialog pre-populated with item data.
Save persists changes; if merge occurs the distinct item count reduces and quantities update correctly.
Cancel leaves original unchanged.
Tests:
Widget test: edit an item to match another item => expect merged row and updated total.
Widget test: edit item and change only bread => expect item updated and total recalculated.
Subtask D — Clear cart
User story: As a customer I want to clear my entire cart to start over.
UI:
Place a small "Clear" TextButton or IconButton in the persistent cart summary area, key cart_clear_button.
Show confirmation dialog ("Clear cart?") or require long-press, OR show undo via Snackbar (choose one per UX preference).
State changes:
Confirmed clear calls cart.clear() and setState; total recalculated via PricingRepository.
Acceptance criteria:
Pressing Clear (and confirming, if applicable) removes all items, sets items count to 0 and total to 0.00.
Undo option (Snackbar) restores previous cart contents if used.
Tests:
Widget test: add items, tap Clear and confirm, expect no items and total 0.00; test Undo restores items.
Subtask E — Persistent summary updates
User story: As a customer I want to see current item count and total price at a glance so I know my order cost.
UI:
Persistent summary in OrderScreen (e.g., Row with Text('Items: X') key cart_item_count and Text('Total: £Y.YY') key cart_total_price), visible at top or bottom of controls.
State changes:
Recomputed using _cart.totalQuantity and cart.totalPriceWithRepository(pricingRepository) on every setState change.
Acceptance criteria:
Summary updates instantaneously after add/edit/remove/clear actions.
Total displayed uses PricingRepository.formatPrice(...) if available.
Tests:
Widget test: press Add to Cart => expect cart_item_count increment and cart_total_price matches repository output.
5. Non-functional requirements
All visual controls use built-in Flutter widgets only.
Widgets must include test keys named as specified.
PricingRepository is the single source of truth for prices; UI must call its methods on every total computation.
Provide semantic labels for accessibility.
Touch targets >= 48x48 logical pixels for interactive icons.
6. Implementation subtasks (developer tasks)
Add UI scaffold for Cart summary on OrderScreen (place Row with keys cart_item_count and cart_total_price).
Implement cart item list widget (ListView.builder or Column) with rows containing name, bread, quantity controls, edit, and delete buttons. Add keys per index.
Implement increment/decrement handlers wired to Cart.add/remove or setQuantity and call setState.
Implement delete behavior + Snackbar undo.
Implement edit dialog/bottom sheet re-using OrderScreen controls; implement merge logic in Cart (or in handler) to combine identical sandwiches.
Implement Clear cart button + confirmation/undo.
Add/Patch Cart model if necessary (mergeOnEdit helper, find by sandwich equality).
Add widget tests for quantity change, delete+undo, edit+merge, clear+undo, and summary update.
Run flutter analyze and fix any accessibility/UX issues.
7. Acceptance test checklist (done criteria)
 Quantity increment/decrement buttons update visible quantity and total.
 Decrement to zero removes item and allows undo.
 Delete removes item and Snackbar Undo restores it.
 Edit dialog allows changing type/size/bread, merges identical items, and updates totals.
 Clear cart removes all with confirmation and undo option.
 Persistent summary shows correct items count and total and updates after every change.
 All interactive widgets include the required test keys.
 Pricing is obtained from PricingRepository for every total calculation.
 Widget tests covering main flows pass.
 App accessible (semantic labels / touch targets).
8. Deliverables
Updated OrderScreen UI code snippets (cart summary + per-item controls).
Cart model helpers or updates to support merging.
Edit dialog implementation.
Snackbar undo implementation.
Widget tests (examples) for quantity change and delete+undo.
Brief README note describing test keys and how to run tests.
End of requirements.