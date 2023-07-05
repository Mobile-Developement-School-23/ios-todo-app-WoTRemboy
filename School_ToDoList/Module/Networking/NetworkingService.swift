//
//  NetworkingService.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 05.07.2023.
//

import Foundation

protocol NetworkingService {
    func get() async
}

class DefaultNetworkingService: NetworkingService {

    private let baseURL = "https://beta.mrdekk.ru/todobackend"

    func get() async {
        guard let url = URL(string: baseURL + "/list") else { return }
        let token = "palaeontologically"
        
        Task {
            var request = URLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            
            do {
                let task = try await URLSession.shared.dataTask(for: request)
                print(task)
            } catch {
                print(error)
            }
        }
    }
}
