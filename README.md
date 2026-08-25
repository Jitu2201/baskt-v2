# Baskt v2

A Flutter app where shop owners set up their own store (name, categories,
products) and manage incoming orders, while customers browse and order
through a simple storefront - no app install or account needed for the
customer.

This version uses **mock/local data only** - everything lives in memory
for the lifetime of the app. There's no backend or login yet.

## Trying both sides of the app

Since there's no login, the app opens on a picker screen: **"I'm a
customer"** or **"I'm a shop owner"**. Pick either to explore that flow.
From the shop owner dashboard, the menu (top right) has "Redo shop
setup" to re-run onboarding, and "Switch app" to go back to the picker.

Customer and owner share the same in-memory data, so an order placed as
a customer immediately shows up in the owner's order list, and updating
an order's status as the owner updates the customer's order tracking
screen live.

## What's implemented

**Customer storefront**
- Home (shop header, categories, product preview)
- Product listing (filterable by category)
- Product detail (with quantity picker)
- Cart
- Checkout
- Order confirmation
- Order tracking (live status timeline)

**Shop owner app**
- Onboarding (shop profile → categories → first products)
- Dashboard (quick stats + recent orders)
- Order management (list + detail, with status updates)

## Running locally

```
flutter pub get
flutter run
```

## Getting a debug APK without a laptop build

Every push to `main` runs `.github/workflows/build-apk.yml`, which builds
a debug APK and uploads it as a workflow artifact. Open the workflow run
under the repo's **Actions** tab and download `baskt-debug-apk` from the
run summary.

## Project structure

```
lib/
  data/       mock seed data
  models/     plain Dart data classes (Shop, Product, Order, ...)
  screens/    UI, split into customer/ and owner/
  state/      ChangeNotifier stores (cart, orders, shop) shared via provider
  theme/      colors, spacing, radius, and the app's ThemeData
  widgets/    small reusable widgets (status badges, empty states, ...)
```
