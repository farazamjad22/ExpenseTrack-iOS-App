//
//  TransactionType.swift
//  ExpenseTrack
//
//  Created by Faraz Amjad on 25.02.26.
//
import SwiftUI

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

enum Category: String, Codable, CaseIterable {
    case groceries     = "Groceries"
    case salary        = "Salary"
    case health        = "Health"
    case transport     = "Transport"
    case entertainment = "Entertainment"
    case utilities     = "Utilities"
    case rent          = "Rent"
    case bills         = "Bills"
    case dining        = "Dining"
    case shopping      = "Shopping"
    case savings       = "Savings"     
    case other         = "Other"

    var icon: String {
        switch self {
        case .groceries:     return "🛒"
        case .salary:        return "💰"
        case .health:        return "💊"
        case .transport:     return "🚗"
        case .entertainment: return "🎬"
        case .utilities:     return "💡"
        case .rent:          return "🏠"
        case .bills:         return "🧾"
        case .dining:        return "🍽️"
        case .shopping:      return "🛍️"
        case .savings:       return "🏦"
        case .other:         return "📦"
        }
    }

    var color: Color {
        switch self {
        case .groceries:     return .green
        case .salary:        return .blue
        case .health:        return .red
        case .transport:     return .orange
        case .entertainment: return .purple
        case .utilities:     return Color(red: 0.9, green: 0.7, blue: 0.0)
        case .rent:          return Color(red: 0.2, green: 0.6, blue: 0.9)
        case .bills:         return Color(red: 0.8, green: 0.4, blue: 0.1)
        case .dining:        return Color(red: 0.95, green: 0.4, blue: 0.4)
        case .shopping:      return Color(red: 0.7, green: 0.3, blue: 0.8)
        case .savings:       return Color(red: 0.1, green: 0.75, blue: 0.5)
        case .other:         return .gray
        }
    }
}


struct Transaction: Identifiable, Codable {
    var id: UUID
    var amount: Double
    var category: Category
    var type: TransactionType
    var date: Date
    var description: String

    init(
        id: UUID = UUID(),
        amount: Double,
        category: Category,
        type: TransactionType,
        date: Date = Date(),
        description: String
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
        self.description = description
    }
}
