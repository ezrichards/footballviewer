//
//  ViewModel.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/1/24.
//

import Foundation
import SwiftUI

struct ViewModel {

    @State var preferencesController = PreferencesController()

    func loadPlayers() async {
        
    }

    func loadSquads() async {
        
    }
    
    
    func loadTeams() async {
        
    }
    
    func loadLeagues() async {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
              print("ERROR:", String(describing: error))
              return
            }
            
            // reference: https://developer.apple.com/documentation/foundation/jsondecoder
            let decoder = JSONDecoder()
            do {
                let newData = try decoder.decode(LeagueJson.self, from: data)
                print("DATA:", newData.response?[0])
            } catch {
                print("error decoding")
            }
        }
        task.resume()
    }
}
