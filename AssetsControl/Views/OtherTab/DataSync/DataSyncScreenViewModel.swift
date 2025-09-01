//
//  DataSyncScreenViewModel.swift
//  AssetsControl
//
//  Created by Igoryok
//

import Foundation

extension DataSyncScreen {
    @MainActor
    class ViewModel: ObservableObject {
        func export(_ data: FinancialData, completion: @escaping (Result<Bool, Error>) -> Void) {
            do {
                let directoryUrl = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)

                let fileUrl = directoryUrl.appendingPathComponent("financialData.findata")
                
                FinancialDataStore.save(data, path: fileUrl, completion: completion)
            } catch {
                print(error)
            }
        }
        
        func `import`(from url: URL, completion: @escaping (Result<FinancialData, Error>) -> Void) {
            FinancialDataStore.load(from: url, completion: completion)
        }
    }
}
