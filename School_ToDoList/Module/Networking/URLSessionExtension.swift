//
//  URLSessionExtension.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 05.07.2023.
//

import Foundation

extension URLSession {
    func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                }
            }
            
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}

// Пользовательский тип ошибки для неизвестных ошибок
struct UnknownError: Error {}
