//
//  ExpensesPdfScannerView.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI
import UniformTypeIdentifiers

struct ExpensesPdfScannerView: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var preferencesDataStore: PreferencesDataStore
    @EnvironmentObject private var userDataStore: UserDataStore

    @StateObject private var viewModel = ExpensesPdfScannerViewModel()

    @Binding var isPresented: Bool
    @Binding var createdExpenses: [Expense]

    var body: some View {
        NavigationView {
            Group {
                if viewModel.showsInitialEmptyState {
                    emptyStateView
                } else {
                    resultsScrollView
                }
            }
            .navigationTitle("Import Bank PDF")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
            .fileImporter(
                isPresented: $viewModel.showPDFImporter,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                viewModel.handleImporterResult(result)
            }
            .sheet(isPresented: $viewModel.showConfirmation) {
                ExpenseConfirmationView(
                    parsedExpenses: $viewModel.parsedExpenses,
                    isPresented: $viewModel.showConfirmation,
                    onConfirm: { expenses in
                        createdExpenses = expenses
                        isPresented = false
                    }
                )
                .environmentObject(financesStore)
            .environmentObject(preferencesDataStore)
                .environmentObject(userDataStore)
            }
            .onAppear {
                viewModel.configureStores(
                    finances: financesStore,
                    preferences: preferencesDataStore,
                    user: userDataStore
                )
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "doc.fill.badge.plus")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            Text("Bank statement PDF")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Pick a PDF from Files or iCloud. Recognised purchases will be turned into expenses you can review before saving.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            sourcePicker
                .padding(.horizontal, 40)

            Button {
                viewModel.openDocumentPicker()
            } label: {
                Label("Choose PDF", systemImage: "folder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)

            Spacer()
        }
    }

    private var sourcePicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Bank")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Bank", selection: $viewModel.selectedSource) {
                Text("Auto-detect").tag(ExpensesPDFSource?.none)
                ForEach(viewModel.availableSources) { source in
                    Text(source.displayName).tag(ExpensesPDFSource?.some(source))
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.12))
            )

            if let source = viewModel.selectedSource {
                Text(source.shortHint)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private var resultsScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let name = viewModel.selectedPDFName {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(name, systemImage: "doc.richtext")
                            .font(.headline)
                        Button {
                            viewModel.resetAndPickDifferentPDF()
                        } label: {
                            Label("Choose different PDF", systemImage: "arrow.triangle.2.circlepath")
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }

                if viewModel.isProcessing {
                    HStack {
                        Spacer()
                        VStack(spacing: 14) {
                            ProgressView()
                                .scaleEffect(1.4)
                            Text("Reading PDF…")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 36)
                }

                if let errorMessage = viewModel.errorMessage {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Could not import", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                if !viewModel.parsedExpenses.isEmpty && !viewModel.isProcessing {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Label("Found \(viewModel.parsedExpenses.count) expense(s)", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.green)
                            Spacer()
                        }
                        .padding(.horizontal)

                        ForEach(viewModel.parsedExpenses) { expense in
                            ExpenseCardView(expense: expense)
                        }

                        Button {
                            viewModel.presentConfirmation()
                        } label: {
                            Label("Review and add", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .padding(.top, 6)
                    }
                }

                if viewModel.parsedExpenses.isEmpty && !viewModel.isProcessing && viewModel.errorMessage == nil && viewModel.selectedPDFName != nil {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        Text("No purchases found")
                            .font(.headline)
                        Text("This PDF has no recognisable purchase rows. Try selecting a specific bank or use a different export.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}
