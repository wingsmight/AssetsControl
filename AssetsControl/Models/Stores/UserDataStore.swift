//
//  UserDataStore.swift
//  AssetsControl
//
//  Created by Igoryok on 03.01.2024.
//

import Foundation

class UserDataStore: ObservableObject {
    private static let fileName = "user.data"

    @Published var data = UserData()

    static func load(completion: @escaping (Result<UserData, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                let file = try FileHandle(forReadingFrom: fileURL)
                let data = try JSONDecoder().decode(UserData.self, from: file.availableData)

                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(_ data: UserData?, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(data)
                let outfile = try fileURL()
                try data.write(to: outfile)

                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func delete(completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let outFile = try fileURL()
                try FileManager.default.removeItem(at: outFile)

                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent(fileName)
    }
}
