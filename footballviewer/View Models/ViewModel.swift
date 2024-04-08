//
//  ViewModel.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/1/24.
//

import Foundation
import SwiftUI

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

struct ViewModel {

    @State var preferencesController = PreferencesController()

    func loadPlayers() async {
//        Task {
            // TODO wrap this function in a task and do and await as needed

            guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
                print("Could not get URL!")
                return
            }

        print("Test")
//        do {
            var request = URLRequest(url: URL(string: "https://v3.football.api-sports.io/leagues")!,timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                  print("ERROR:", String(describing: error))
                  return
                }
                
                guard data.count != 0 else {
                    print("Zero bytes of data")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let newData = try decoder.decode(Json4Swift_Base.self, from: data)
                    print("DATA:", newData.response?[0])
                } catch {
                    print("error decoding")
                }
            }
            task.resume()

//        }
//        catch {
//            print("ERROR")
//        }
        print("AFTER")

            // resource used: https://developer.apple.com/documentation/foundation/jsondecoder
//            let decoder = JSONDecoder()
//            let data = try? decoder.decode(GroceryProduct.self, from: urlSession)
//            
//            print(data)
//        }
    }
}
