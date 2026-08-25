# Session Log

This file is a running record of explanations and decisions I (Claude)
give during our chat sessions on this project. Per your request, from
the point this file was created onward, every substantive explanation
or decision is copied into this file in full and pushed alongside the
code changes it relates to.

Entries before this file existed are a best-effort summary reconstructed
from the conversation, not verbatim quotes — I didn't have a log file to
write into yet at that point in the session.

---

## Summary of decisions made earlier in this session (before this log existed)

- **Flutter SDK**: no Flutter/Dart toolchain was preinstalled in this
  environment, so I downloaded the stable Flutter SDK (3.35.5) directly
  from Google's release server and extracted it to `/opt/flutter-sdk`,
  rather than hand-writing the Android project scaffold. This let me run
  `flutter create` for correct, real Android Gradle/manifest boilerplate
  instead of guessing at it, and let me run `flutter analyze`/`flutter
  test` locally to catch mistakes before pushing.

- **Design file access**: you asked me to match a Claude Design file
  exactly, but the `DesignSync` MCP tool couldn't authenticate in this
  remote/non-interactive session (`/design-login` needs an interactive
  terminal, which this environment doesn't have). I asked you how you'd
  like to proceed (via `AskUserQuestion`), and you chose to use Claude
  Design's "Send to Claude Code Web" action to seed the design files
  into the workspace directly. That import is still pending as of this
  entry — I've continued building the app architecture and a reasonable
  placeholder navy/white/rounded-corner theme in the meantime so I'm not
  blocked, and I'll reconcile colors/spacing/layout exactly once the
  design files land.

- **Repo hygiene**: the root `.gitignore` that existed before `flutter
  create` was a minimal pub-only one, missing standard entries for IDE
  files (`.idea/`, `*.iml`) and platform build artifacts. I replaced it
  with the standard Flutter `.gitignore` (IDE files, build output,
  `android/local.properties`, keystores, iOS derived-data, etc.) so
  machine-specific and generated files never get committed.

- **CI**: added `.github/workflows/build-apk.yml` — on every push to
  `main` it checks out the repo, sets up Java 17 + Flutter stable, runs
  `flutter pub get`, `flutter analyze`, then `flutter build apk --debug`
  and uploads the resulting APK as a downloadable workflow artifact
  (`baskt-debug-apk`, 30-day retention), since you test via APK download
  rather than a laptop toolchain.

- **State management**: chose `provider` (ChangeNotifier-based stores)
  over something heavier like Riverpod or Bloc, since it's the simplest
  mental model for someone learning Flutter, and it's still what
  Flutter's own docs recommend for small-to-medium apps.

- **No backend yet**: `ShopStore`, `CartStore`, and `OrderStore` all
  hold everything in memory for the lifetime of the app. `ShopStore` and
  `OrderStore` are shared between the customer and owner sides of the
  app (there's no real backend to separate them), so an order placed on
  the customer side, or a status update made on the owner side, is
  visible on both immediately — useful for testing the full loop from a
  single APK.

- **Single-app role picker**: since there's no login yet, the app opens
  on a "Baskt" role-picker screen ("I'm a customer" / "I'm a shop
  owner"). Each role has a "Switch app" action to jump back to the
  picker, so you can test both sides from one install. The owner
  dashboard also has a "Redo shop setup" menu action that resets the
  shop and replays onboarding, since the app ships with demo data
  (Corner Cafe) pre-loaded so the customer storefront isn't empty on
  first launch.

- **Screens built**: customer side — home (shop header + categories +
  product preview grid), full product listing (with category filter
  chips), product detail (with quantity stepper and add-to-cart), cart,
  checkout (contact form + order summary), order confirmation, and order
  tracking (a live status timeline that updates automatically when the
  owner changes the order's status). Owner side — a 3-step onboarding
  wizard (shop profile → categories → first products), a dashboard
  (pending orders / total revenue stats + recent orders), and order
  management (order list + detail screen with status-advance and cancel
  actions).

- **Validation**: ran `flutter pub get`, `flutter analyze` (no issues),
  and `flutter test` (3 widget tests covering the role picker and both
  app entry points — all passing) before committing.

---

## 2026-08-24 — Adding this session log

You asked me to keep a `SESSION_LOG.md` file in the repo, and to write
the full text of every explanation or decision I give you into that
file (not summarized), committed and pushed alongside the related code
changes. This entry, and the summary section above it, are the result
of setting that up. Going forward, each new explanation I give you in
chat gets appended here verbatim before I commit.
