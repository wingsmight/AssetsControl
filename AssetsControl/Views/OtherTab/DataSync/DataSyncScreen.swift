//
//  DataSyncScreen.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

struct DataSyncScreen: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    
    @StateObject private var model: ViewModel = .init()
    
    @State private var text: String = ""
    @State private var selectedFileURL: URL?
    @State private var fileContent: String = ""
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        List {
            Button("Export .findata") {
                model.export(financesStore.data) { result in
                    switch result {
                    case .success:
                        self.text = "Data exported successfully"
                    case .failure(let error):
                        self.text = "Data export failed with error: \(error)"
                    }
                }
            }

            Button("Import .findata") {
                isPickerPresented.toggle()
            }
            .sheet(isPresented: $isPickerPresented) {
                DocumentPicker(fileURL: $selectedFileURL)
            }
            
            Spacer()
            
            Text(text)
            
            if let selectedFileURL {
                Text("Selected File: \(selectedFileURL.lastPathComponent)")
                    .font(.headline)
                    .padding()
                
                ScrollView {
                    Text(fileContent.isEmpty ? "File is empty or couldn't be read." : fileContent)
                        .padding()
                }
                .frame(maxHeight: 300)
            }
        }
        .navigationTitle("Data Sync")
        .onChange(of: selectedFileURL) { newURL in
            guard let newURL else { return }

            model.import(from: newURL) { result in
                switch result {
                case .success(let data):
                    self.text = "Data imported successfully"
                    financesStore.data = data
                case .failure(let error):
                    self.text = "Data import failed with error: \(error)"
                }
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(fileURL: $fileURL)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var fileURL: URL?
        
        init(fileURL: Binding<URL?>) {
            _fileURL = fileURL
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            fileURL = urls.first
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            fileURL = nil
        }
    }
}


#Preview {
    DataSyncScreen()
}
