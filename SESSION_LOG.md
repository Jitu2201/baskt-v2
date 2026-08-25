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

---

## 2026-08-25 — Fixing the Gradle version mismatch in the APK build

That error comes from Flutter's own Gradle version check, and it's
independent of the Android Gradle Plugin (AGP) version in the project —
I confirmed AGP 8.9.1 (already in `android/settings.gradle.kts`) is
compatible with Gradle 8.14, so bumping just the wrapper is the right
fix. I bumped `android/gradle/wrapper/gradle-wrapper.properties` from
Gradle 8.12 → 8.14.

I can't fully rebuild the APK locally to double-check, since this
sandbox's network policy blocks `dl.google.com` (where the Android SDK
components live) — only the CI runner has that access. Let me commit
this and push so the next Actions run validates it for real.

---

## 2026-08-25 — Opening a PR for the Gradle fix

The Gradle fix had been pushed straight to
`claude/baskt-v2-flutter-setup-1lvx1q`, but that branch's earlier work
was already merged into `main` via PR #1 before I made the fix - so the
fix commit was sitting on top of already-merged history on the same
branch name, with nothing open for you to merge.

To clean that up: I reset the branch to start from the current `main`,
cherry-picked just the Gradle fix commit onto it, and force-pushed
(safe here since the only thing being discarded from the branch was
history that's already on `main` - the fix commit itself was kept).
Then I opened PR #2 (`Bump Gradle wrapper to 8.14 to fix debug APK
build`) from that branch into `main` for you to review and merge:
https://github.com/Jitu2201/baskt-v2/pull/2

---

## 2026-08-25 — Bumping AGP after a follow-on build failure

The Gradle bump surfaced a second, related error: Flutter now also
requires Android Gradle Plugin (AGP) 8.11.1 minimum, and the project was
still on AGP 8.9.1 (set in `android/settings.gradle.kts`). I bumped it
to 8.11.1, which is compatible with the Gradle 8.14 wrapper we're
already on (AGP 8.11.1's own minimum Gradle requirement is 8.13, so
8.14 satisfies it). `compileSdk`/`minSdk`/`targetSdk` in
`android/app/build.gradle.kts` are all pulled from Flutter's own
`flutter.*Version` values rather than hardcoded, so they stay in sync
automatically and didn't need a manual change.

`flutter analyze` still passes with no issues. This commit is going
onto the same PR #2 branch, since that PR hasn't been merged yet.

---

## 2026-08-25 — Opening a new PR for the AGP fix

You checked GitHub and PR #2 had already been merged, so the AGP fix
commit I'd pushed onto that same branch afterward wasn't reachable from
`main` - same situation as last time. I did the same cleanup: reset the
branch to the current `main` (now including the merged Gradle fix),
cherry-picked just the AGP commit onto it, and force-pushed. Then
opened PR #3 (`Bump AGP to 8.11.1 to fix debug APK build`) for you to
review and merge: https://github.com/Jitu2201/baskt-v2/pull/3

---

## 2026-08-25 — New standing rule: check GitHub's main before starting a new fix

You asked me to check GitHub for the latest `main` before starting any
new fix from now on, so we don't hit the "branch already merged, new
commit stranded" situation a third time. Agreed - from this point on,
before starting a new change I'll fetch `origin/main` and compare it
against the working branch first. If the branch's prior history has
already been merged, I'll reset the branch to current `main` before
adding new commits, rather than building on top of stale/merged
history and finding out only after pushing.

---

## 2026-08-25 — Kotlin version fix, plus checking all version requirements at once

Checked `main` first per the new rule - PR #3 was already merged, and
this time the local branch was already even with it, so no rebase was
needed before starting.

For the actual fix: rather than patch the Kotlin version and wait to
see what breaks next, I upgraded my local Flutter SDK to the same
release channel your CI uses (`channel: stable`, which is a moving
target - it had drifted to Flutter 3.47.1 since I last checked), then
read the exact version thresholds straight from that release's own
source (`DependencyVersionChecker.kt` in `flutter_tools`), instead of
inferring them from compatibility tables like I did for the Gradle/AGP
fixes. That file defines the real minimums Flutter enforces:

- Gradle: error below 8.14.0, warn below 9.1.0 - we're at 8.14, already fine.
- Java: error/warn at 17 - your CI workflow already uses Java 17, already fine.
- AGP: error below 8.11.1, warn below 9.0.1 - we're at 8.11.1, already fine.
- Kotlin (KGP): error below 2.2.20, warn below 2.3.20 - we were at 2.1.0, which is what broke. Bumped to 2.2.20.

So Kotlin was the only one left to fix; nothing else is currently below
its minimum. I bumped `org.jetbrains.kotlin.android` from 2.1.0 to
2.2.20 in `android/settings.gradle.kts`.

I still can't fully rebuild the APK here to confirm end-to-end - the
Gradle-level version check only runs once Gradle actually starts, which
requires the Android SDK, and this sandbox's network policy blocks
`dl.google.com` where that lives. I did confirm `flutter analyze` and
`flutter test` still pass clean on the upgraded local Flutter SDK, and
that `flutter build apk --debug` gets past dependency resolution before
stopping at the expected "No Android SDK found" (an environment
limitation here, not a version problem) - it did not hit any
Gradle/AGP/Kotlin version error, which is what I'd expect if the fix is
correct, though it's not a full guarantee since the actual
Gradle-plugin version check task never got to run in this environment.

One thing worth flagging: because your CI workflow uses `channel:
stable` rather than a pinned version, Flutter's own minimum-version
requirements can shift again on some future run, independent of
anything in this repo changing. If you'd rather avoid that treadmill,
I can pin the workflow to a specific Flutter version (e.g. 3.47.1) so
builds stay reproducible until you deliberately bump it - happy to do
that if you want, just let me know.

---

## 2026-08-25 — Opening PR #4 for the Kotlin fix

Pushed the Kotlin bump to `claude/baskt-v2-flutter-setup-1lvx1q` and
opened PR #4 (`Bump Kotlin (KGP) to 2.2.20 to fix debug APK build`) for
you to review and merge: https://github.com/Jitu2201/baskt-v2/pull/4.
No rebase was needed this time since I'd already confirmed the branch
was even with `main` before starting.
