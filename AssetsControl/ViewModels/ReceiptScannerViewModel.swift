//
//  ReceiptScannerViewModel.swift
//  AssetsControl
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI
import Vision
import VisionKit

@MainActor
class ReceiptScannerViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var recognizedText: String = ""
    @Published var parsedExpenses: [ParsedExpense] = []
    @Published var errorMessage: String?
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage?
    
    struct ParsedExpense: Identifiable {
        let id = UUID()
        var name: String
        var amount: Double
        var currency: Currency
        var date: Date

        var isValid: Bool {
            !name.isEmpty && amount > 0
        }
    }
    
    func processImage(_ image: UIImage) {
        isProcessing = true
        errorMessage = nil
        recognizedText = ""
        parsedExpenses = []
        selectedImage = image
        
        guard let cgImage = image.cgImage else {
            errorMessage = "Failed to process image"
            isProcessing = false
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            Task { @MainActor in
                self?.handleDetectionResults(request: request, error: error)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US", "ru-RU"]
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                Task { @MainActor in
                    self.errorMessage = "Text recognition failed: \(error.localizedDescription)"
                    self.isProcessing = false
                }
            }
        }
    }
    
    private func handleDetectionResults(request: VNRequest, error: Error?) {
        if let error = error {
            errorMessage = "Recognition error: \(error.localizedDescription)"
            isProcessing = false
            return
        }
        
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            errorMessage = "No text found in image"
            isProcessing = false
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        
        recognizedText = recognizedStrings.joined(separator: "\n")
        parseExpenses(from: recognizedStrings)
        isProcessing = false
    }
    
    private func parseExpenses(from lines: [String]) {
        var expenses: [ParsedExpense] = []
        var detectedCurrency: Currency = .dollar
        
        // Try to detect currency from the text
        let allText = lines.joined(separator: " ").lowercased()
        if allText.contains("₽") || allText.contains("руб") || allText.contains("rub") {
            detectedCurrency = .russianRuble
        } else if allText.contains("€") || allText.contains("eur") {
            detectedCurrency = .euro
        } else if allText.contains("£") || allText.contains("gbp") {
            detectedCurrency = .poundSterling
        }
        
        for line in lines {
            // Try to find amount patterns (e.g., "123.45", "1,234.56", "123,45")
            let patterns = [
                #"(\d{1,3}(?:[,\s]\d{3})*(?:[.,]\d{2})?)"#,  // 1,234.56 or 1 234.56
                #"(\d+[.,]\d{2})"#,                            // 123.45
                #"(\d+)"#                                      // 123
            ]
            
            for pattern in patterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: line, options: [], range: NSRange(line.startIndex..., in: line)) {
                    
                    if let range = Range(match.range(at: 1), in: line) {
                        let amountString = String(line[range])
                        // Clean up the amount string
                        let cleanAmount = amountString
                            .replacingOccurrences(of: ",", with: ".")
                            .replacingOccurrences(of: " ", with: "")
                        
                        if let amount = Double(cleanAmount), amount > 0 {
                            // Extract name (everything before the amount)
                            let nameRange = line.startIndex..<range.lowerBound
                            var name = String(line[nameRange])
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            // If name is empty, try to get it from after the amount
                            if name.isEmpty {
                                let afterAmountRange = range.upperBound..<line.endIndex
                                name = String(line[afterAmountRange])
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            
                            // Clean up currency symbols from name
                            name = name
                                .replacingOccurrences(of: "₽", with: "")
                                .replacingOccurrences(of: "$", with: "")
                                .replacingOccurrences(of: "€", with: "")
                                .replacingOccurrences(of: "£", with: "")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            if !name.isEmpty || amount > 10 { // Include items with amount > 10 even without name
                                if name.isEmpty {
                                    name = "Expense"
                                }
                                
                                expenses.append(ParsedExpense(
                                    name: name,
                                    amount: amount,
                                    currency: detectedCurrency,
                                    date: Date()
                                ))
                                break // Found amount in this line, move to next line
                            }
                        }
                    }
                }
            }
        }
        
        // Remove duplicates and very similar entries
        var uniqueExpenses: [ParsedExpense] = []
        for expense in expenses {
            let isDuplicate = uniqueExpenses.contains { existing in
                abs(existing.amount - expense.amount) < 0.01 &&
                existing.name.lowercased() == expense.name.lowercased() &&
                Calendar.current.isDate(existing.date, inSameDayAs: expense.date)
            }
            if !isDuplicate {
                uniqueExpenses.append(expense)
            }
        }
        
        parsedExpenses = uniqueExpenses
    }
    
    func reset() {
        recognizedText = ""
        parsedExpenses = []
        errorMessage = nil
        selectedImage = nil
        isProcessing = false
    }
}

