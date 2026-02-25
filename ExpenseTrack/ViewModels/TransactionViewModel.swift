//
//  TransactionViewModel.swift
//  ExpenseTrack
//
//  Created by Faraz Amjad on 25.02.26.
//


import Foundation
internal import Combine

@MainActor
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    private let storageKey = "expensetrack_transactions"

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    init() {
        loadTransactions()
    }

    // MARK: - Computed Properties

    var totalBalance: Double {
        transactions.reduce(0.0) { result, t in
            t.type == .income ? result + t.amount : result - t.amount
        }
    }

    var totalExpenses: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0.0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0.0) { $0 + $1.amount }
    }

    var expenseCount: Int {
        transactions.filter { $0.type == .expense }.count
    }

    var incomeCount: Int {
        transactions.filter { $0.type == .income }.count
    }

    var transactionsByDate: [(key: String, value: [Transaction])] {
        let grouped = Dictionary(grouping: transactions) { transaction in
            Self.dateFormatter.string(from: transaction.date)
        }
        return grouped.sorted { a, b in
            let dateA = Self.dateFormatter.date(from: a.key) ?? .distantPast
            let dateB = Self.dateFormatter.date(from: b.key) ?? .distantPast
            return dateA > dateB
        }
    }

    // MARK: - Actions

    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }

    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }

    // MARK: - Persistence

    private func saveTransactions() {
        guard let encoded = try? JSONEncoder().encode(transactions) else { return }
        UserDefaults.standard.set(encoded, forKey: storageKey)
    }

    private func loadTransactions() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return }
        transactions = decoded
    }
}
