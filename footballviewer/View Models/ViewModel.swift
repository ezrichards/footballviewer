//
//  ViewModel.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/1/24.
//

import Foundation

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

struct ViewModel {
    
    func loadPlayers() async {
//        Task {
            // TODO wrap this function in a task and do and await as needed

            guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
                print("Could not get URL!")
                return
            }

        print("Test")
        do {
            var urlSession = try? await URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                print(data)
                print(response)
                print(error)
            }

        }
        catch {
            print("ERROR")
        }
        print("AFTER")

            // resource used: https://developer.apple.com/documentation/foundation/jsondecoder
//            let decoder = JSONDecoder()
//            let data = try? decoder.decode(GroceryProduct.self, from: urlSession)
//            
//            print(data)
//        }
    }
}
