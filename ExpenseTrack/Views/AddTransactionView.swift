//
//  AddTransactionView.swift
//  ExpenseTrack
//
//  Created by Faraz Amjad on 25.02.26.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amountText = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category = .other
    @State private var descriptionText = ""
    @FocusState private var isAmountFocused: Bool

    private var parsedAmount: Double? {
        Double(amountText.replacingOccurrences(of: ",", with: "."))
    }

    private var isValidAmount: Bool {
        (parsedAmount ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Amount
                Section {
                    HStack(alignment: .center, spacing: 6) {
                        Text("€")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .focused($isAmountFocused)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Amount")
                }

                // MARK: Type Toggle
                Section {
                    Picker("", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 4)
                } header: {
                    Text("Type")
                }

                // MARK: Category
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)")
                            .tag(category)
                        }
                    }
                } header: {
                    Text("Category")
                }

                // MARK: Description
                Section {
                    TextField("Add a note…", text: $descriptionText, axis: .vertical)
                        .lineLimit(3, reservesSpace: false)
                } header: {
                    Text("Description")
                }

                // MARK: Save Button
                Section {
                    Button(action: saveTransaction) {
                        HStack {
                            Spacer()
                            Label("Save Transaction", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isValidAmount
                                  ? LinearGradient(colors: [.indigo, Color(red: 0.55, green: 0.2, blue: 0.9)],
                                                   startPoint: .leading, endPoint: .trailing)
                                  : LinearGradient(colors: [Color.gray.opacity(0.35), Color.gray.opacity(0.35)],
                                                   startPoint: .leading, endPoint: .trailing))
                    )
                    .disabled(!isValidAmount)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                isAmountFocused = true
            }
        }
    }

    private func saveTransaction() {
        guard let amount = parsedAmount, amount > 0 else { return }
        let transaction = Transaction(
            amount: amount,
            category: selectedCategory,
            type: selectedType,
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        viewModel.addTransaction(transaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView(viewModel: TransactionViewModel())
}
