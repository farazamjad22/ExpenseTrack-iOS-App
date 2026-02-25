//
//  ContentView.swift
//  ExpenseTrack
//
//  Created by Faraz Amjad on 25.02.26.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var showingAddTransaction = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                // ── Header + Cards ──────────────────────────
                Section {
                    VStack(spacing: 20) {
                        headerView
                        balanceCard
                        statCards
                    }
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 8, trailing: 20))
                .listRowSeparator(.hidden)
                .listRowBackground(Color(.systemGroupedBackground))

                // ── Transactions title ──────────────────────
                Section {
                    Text("Transactions")
                }
                .font(.title3)
                .fontWeight(.bold)
                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20))
                .listRowSeparator(.hidden)
                .listRowBackground(Color(.systemGroupedBackground))

                // ── Transaction rows or empty state ─────────
                if viewModel.transactions.isEmpty {
                    Section {
                        emptyState
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemGroupedBackground))
                } else {
                    ForEach(viewModel.transactionsByDate, id: \.key) { group in
                        Section {
                            ForEach(group.value.sorted { $0.date > $1.date }) { transaction in
                                TransactionRowView(transaction: transaction)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                viewModel.deleteTransaction(transaction)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                            }
                        } header: {
                            Text(group.key)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .textCase(nil)
                        }
                    }
                }

                // Bottom spacer so FAB doesn't overlap the last row
                Section {}
                    .listRowBackground(Color.clear)
                    .frame(height: 80)
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(.zero)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))

            // ── FAB ─────────────────────────────────────
            Button {
                showingAddTransaction = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 62, height: 62)
                    .background(
                        LinearGradient(
                            colors: [.indigo, Color(red: 0.55, green: 0.2, blue: 0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .indigo.opacity(0.5), radius: 14, x: 0, y: 7)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 36)
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(viewModel: viewModel)
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Expense Track")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your financial overview")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.12))
                    .frame(width: 50, height: 50)
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundStyle(.indigo)
            }
        }
    }

    // MARK: - Balance Card

    private var balanceCard: some View {
        VStack(spacing: 10) {
            Text("Total Balance")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.85))

            Text(viewModel.totalBalance, format: .currency(code: "EUR"))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            HStack(spacing: 5) {
                Image(systemName: "list.bullet")
                    .font(.caption2)
                Text("\(viewModel.transactions.count) transaction\(viewModel.transactions.count == 1 ? "" : "s")")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white.opacity(0.75))
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.18))
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.36, green: 0.27, blue: 0.95),
                    Color(red: 0.58, green: 0.18, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .indigo.opacity(0.38), radius: 22, x: 0, y: 10)
    }

    // MARK: - Stat Cards

    private var statCards: some View {
        HStack(spacing: 14) {
            StatCard(
                title: "Expenses",
                amount: viewModel.totalExpenses,
                count: viewModel.expenseCount,
                accentColor: .red,
                systemIcon: "arrow.down.circle.fill"
            )
            StatCard(
                title: "Income",
                amount: viewModel.totalIncome,
                count: viewModel.incomeCount,
                accentColor: .green,
                systemIcon: "arrow.up.circle.fill"
            )
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.08))
                    .frame(width: 90, height: 90)
                Image(systemName: "tray.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.indigo.opacity(0.4))
            }
            Text("No transactions yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Tap the + button to add your first transaction")
                .font(.subheadline)
                .foregroundStyle(Color.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

// MARK: - StatCard

struct StatCard: View {
    let title: String
    let amount: Double
    let count: Int
    let accentColor: Color
    let systemIcon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemIcon)
                    .font(.title3)
                    .foregroundStyle(accentColor)
                Spacer()
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(amount, format: .currency(code: "EUR"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - TransactionRowView

struct TransactionRowView: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            // Category badge: emoji + category name stacked
            VStack(spacing: 3) {
                Text(transaction.category.icon)
                    .font(.system(size: 20))
                Text(transaction.category.rawValue)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(transaction.category.color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .frame(maxWidth: 52)
            }
            .frame(width: 54, height: 54)
            .background(transaction.category.color.opacity(0.13))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Description + type tag
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description.isEmpty
                     ? transaction.category.rawValue
                     : transaction.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(transaction.type == .expense ? "Expense" : "Income")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(transaction.type == .expense ? Color.red : Color.green)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background((transaction.type == .expense ? Color.red : Color.green).opacity(0.10))
                    .clipShape(Capsule())
            }

            Spacer()

            // Amount with ▼/▲ indicator
            HStack(spacing: 2) {
                Text(transaction.type == .expense ? "▼" : "▲")
                    .font(.system(size: 9, weight: .bold))
                Text(transaction.amount, format: .currency(code: "EUR"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(transaction.type == .expense ? Color.red : Color.green)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
