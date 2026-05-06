//
//  ReceiptScannerView.swift
//  AssetsControl
//
//  Created by AI Assistant
//

import SwiftUI

struct ReceiptScannerView: View {
    @StateObject private var viewModel = ReceiptScannerViewModel()
    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var preferencesDataStore: PreferencesDataStore
    @EnvironmentObject private var userDataStore: UserDataStore
    
    @Binding var isPresented: Bool
    @Binding var createdExpenses: [Expense]
    
    @State private var showImagePicker = false
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.selectedImage == nil {
                    imagePickerView
                } else {
                    resultsView
                }
            }
            .navigationTitle("Scan Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage, isPresented: $showImagePicker) { image in
                    viewModel.processImage(image)
                }
            }
            .sheet(isPresented: $showConfirmation) {
                ExpenseConfirmationView(
                    parsedExpenses: $viewModel.parsedExpenses,
                    isPresented: $showConfirmation,
                    onConfirm: { expenses in
                        createdExpenses = expenses
                        isPresented = false
                    }
                )
                .environmentObject(financesStore)
                .environmentObject(preferencesDataStore)
                .environmentObject(userDataStore)
            }
        }
    }
    
    private var imagePickerView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Select Receipt Image")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Choose a photo of your receipt or expense to automatically extract transaction details")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showImagePicker = true
            } label: {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Choose Photo")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let image = viewModel.selectedImage {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        Button(action: {
                            viewModel.reset()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Select Different Image")
                            }
                            .font(.subheadline)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
                
                if viewModel.isProcessing {
                    HStack {
                        Spacer()
                        VStack(spacing: 15) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Processing image...")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 40)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Error", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                if !viewModel.parsedExpenses.isEmpty && !viewModel.isProcessing {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Label("Found \(viewModel.parsedExpenses.count) expense(s)", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.parsedExpenses) { expense in
                            ExpenseCardView(expense: expense)
                        }
                        
                        Button(action: {
                            showConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Review and Add Expenses")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
                
                if !viewModel.recognizedText.isEmpty && viewModel.parsedExpenses.isEmpty && !viewModel.isProcessing {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("No expenses found", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("Couldn't extract expense information automatically. Recognized text:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.recognizedText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ExpenseCardView: View {
    let expense: ReceiptScannerViewModel.ParsedExpense
    
    var body: some View {
        HStack {
            Image(systemName: "tag.fill")
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.name)
                    .font(.headline)
                Text(expense.currency.code)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(expense.amount, specifier: "%.2f") \(expense.currency.symbol)")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ExpenseConfirmationView: View {
    @Binding var parsedExpenses: [ReceiptScannerViewModel.ParsedExpense]
    @Binding var isPresented: Bool
    let onConfirm: ([Expense]) -> Void
    
    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var preferencesDataStore: PreferencesDataStore
    @EnvironmentObject private var userDataStore: UserDataStore
    
    @State private var selectedExpenses: Set<UUID> = []
    @State private var expenseNames: [UUID: String] = [:]
    @State private var expenseAmounts: [UUID: String] = [:]
    @State private var expenseSymbols: [UUID: Symbol] = [:]
    @State private var moneyHolderSource: MoneyHolder = .init(name: "default")
    @State private var expenseDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Date", selection: $expenseDate)
                }
                
                Section {
                    MoneyHolderPicker(selected: $moneyHolderSource,
                                    moneyHolders: financesStore.data.moneyHolders)
                }
                
                Section(header: Text("Select Expenses to Add")) {
                    ForEach(parsedExpenses) { expense in
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: Binding(
                                get: { selectedExpenses.contains(expense.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedExpenses.insert(expense.id)
                                        expenseNames[expense.id] = expense.name
                                        expenseAmounts[expense.id] = String(format: "%.2f", expense.amount)
                                        expenseSymbols[expense.id] = .banknote
                                    } else {
                                        selectedExpenses.remove(expense.id)
                                        expenseNames.removeValue(forKey: expense.id)
                                        expenseAmounts.removeValue(forKey: expense.id)
                                        expenseSymbols.removeValue(forKey: expense.id)
                                    }
                                }
                            )) {
                                VStack(alignment: .leading) {
                                    Text(expense.name)
                                        .font(.headline)
                                    Text("\(expense.amount, specifier: "%.2f") \(expense.currency.symbol)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if selectedExpenses.contains(expense.id) {
                                VStack(spacing: 12) {
                                    TextField("Name", text: Binding(
                                        get: { expenseNames[expense.id] ?? expense.name },
                                        set: { expenseNames[expense.id] = $0 }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    TextField("Amount", text: Binding(
                                        get: { expenseAmounts[expense.id] ?? String(format: "%.2f", expense.amount) },
                                        set: { expenseAmounts[expense.id] = $0 }
                                    ))
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Picker("Symbol", selection: Binding(
                                        get: { expenseSymbols[expense.id] ?? .banknote },
                                        set: { expenseSymbols[expense.id] = $0 }
                                    )) {
                                        ForEach(Symbol.allCases) { symbol in
                                            Label(symbol.suggestedTitle, systemImage: symbol.systemImageName)
                                                .tag(symbol)
                                        }
                                    }
                                }
                                .padding(.leading, 30)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Confirm Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSelectedExpenses()
                    }
                    .disabled(selectedExpenses.isEmpty)
                }
            }
            .onAppear {
                // Select all by default
                for expense in parsedExpenses {
                    selectedExpenses.insert(expense.id)
                    expenseNames[expense.id] = expense.name
                    expenseAmounts[expense.id] = String(format: "%.2f", expense.amount)
                    expenseSymbols[expense.id] = .banknote
                }
                
                // Set default money holder
                if let firstMoneyHolder = financesStore.data.moneyHolders.first {
                    moneyHolderSource = getDefaultMoneyHolderSource()
                }
            }
        }
    }
    
    private func addSelectedExpenses() {
        var expenses: [Expense] = []
        
        for expenseId in selectedExpenses {
            guard let parsedExpense = parsedExpenses.first(where: { $0.id == expenseId }),
                  let name = expenseNames[expenseId],
                  let amountString = expenseAmounts[expenseId],
                  let amount = Double(amountString.replacingOccurrences(of: ",", with: ".")),
                  let symbol = expenseSymbols[expenseId] else {
                continue
            }
            
            let money = Money(amount, of: parsedExpense.currency)
            let expense = Expense(
                name: name,
                symbol: symbol,
                amount: money,
                moneyHolderSource: moneyHolderSource,
                date: expenseDate
            )
            expenses.append(expense)
        }
        
        onConfirm(expenses)
    }
    
    private func getDefaultMoneyHolderSource() -> MoneyHolder {
        switch preferencesDataStore.data.defaultMoneyHolderSourceMethod {
        case .selected(let moneyHolder):
            return moneyHolder ?? MoneyHolder.test
        case .ai, .lastUsed:
            let firstMoneyHolder = financesStore.data.moneyHolders.first
            return userDataStore.data.lastMoneyHolderSource ?? firstMoneyHolder ?? MoneyHolder.test
        }
    }
}

// MARK: - ImagePicker (UIKit Wrapper for iOS 15 compatibility)

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    let onImageSelected: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.onImageSelected(image)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
