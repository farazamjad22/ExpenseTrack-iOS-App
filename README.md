# ExpenseTrack 💰

A clean, modern **iOS expense tracking app** built with SwiftUI using the MVVM architecture pattern. Track your income and expenses, view a live balance summary, and manage your transactions effortlessly.

---

## Features

- 📊 **Live Balance Card** — Total balance updates the instant a transaction is added or deleted
- 🔴🟢 **Expense & Income Summary** — Side-by-side stat cards showing total amount and count for each type
- 📅 **Date-Grouped Transactions** — Transactions grouped by date with native swipe-to-delete
- 🏷️ **Category Badges** — Colorful emoji + category name badge on every transaction row
- ➕ **Add Transaction Sheet** — Clean modal with amount input, Income/Expense toggle, category picker, and an optional note
- 💾 **Persistent Storage** — All transactions saved locally with `UserDefaults` + `JSONEncoder`
- 💶 **EUR Currency** — All amounts displayed in Euro (€) with 2 decimal places

---

## Tech Stack

| | |
|---|---|
| **Language** | Swift 5 |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM |
| **Persistence** | UserDefaults + JSONEncoder / JSONDecoder |
| **Minimum iOS** | iOS 26.2 |
| **Dependencies** | None |

---

## Project Structure

```
ExpenseTrack/
├── ExpenseTrackApp.swift              # @main entry point
├── Models/
│   └── Transaction.swift             # Transaction struct, Category & TransactionType enums
├── ViewModels/
│   └── TransactionViewModel.swift    # Business logic, computed totals, CRUD, persistence
└── Views/
    ├── ContentView.swift             # Main screen — balance card, stat cards, transaction list, FAB
    └── AddTransactionView.swift      # Add transaction sheet modal
```

---

## Data Model

### `Transaction`

| Field | Type | Description |
|---|---|---|
| `id` | `UUID` | Auto-generated unique identifier |
| `amount` | `Double` | Transaction amount in EUR |
| `category` | `Category` | One of 12 categories |
| `type` | `TransactionType` | `.income` or `.expense` |
| `date` | `Date` | Date the transaction was recorded |
| `description` | `String` | Optional user note |

### Categories

| Emoji | Category | Color |
|---|---|---|
| 🛒 | Groceries | Green |
| 💰 | Salary | Blue |
| 💊 | Health | Red |
| 🚗 | Transport | Orange |
| 🎬 | Entertainment | Purple |
| 💡 | Utilities | Yellow |
| 🏠 | Rent | Light Blue |
| 🧾 | Bills | Brown |
| 🍽️ | Dining | Coral |
| 🛍️ | Shopping | Violet |
| 🏦 | Savings | Teal |
| 📦 | Other | Gray |

---

## Getting Started

### Requirements

- Xcode 17 or later
- iOS 26.2 Simulator or a physical device running iOS 26.2+

### Run Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/farazamjad22/ExpenseTrack-iOS-App.git
   cd ExpenseTrack
   ```

2. **Open in Xcode**
   ```bash
   open ExpenseTrack.xcodeproj
   ```

3. **Select a simulator or device**, then press **⌘ + R** to build and run.

> No package manager setup needed — zero external dependencies.

---

## Usage

| Action | How to do it |
|---|---|
| **Add a transaction** | Tap the **+** FAB button (bottom-right) |
| **Delete a transaction** | **Swipe left** on any transaction row → tap Delete |
| **View total balance** | Balance card at the top — updates live |
| **View totals by type** | Expenses (🔴) and Income (🟢) stat cards below the balance |

---

## Screenshots

<img width="360" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 23 45 28" src="https://github.com/user-attachments/assets/c004ea2e-5f45-4739-b91f-afab13cb57ee" />
<img width="360" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 23 45 12" src="https://github.com/user-attachments/assets/1aa0c604-f223-4980-a2f2-8bbbe46d6430" />

