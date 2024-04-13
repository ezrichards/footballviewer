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

    func loadPlayers(withId id: String, withSeasonId seasonId: String) async {
        // https://v3.football.api-sports.io/players?id=909&season=2023
        guard let url = URL(string: "https://v3.football.api-sports.io/players?id=\(id)&season=\(seasonId)") else {
            print("Could not get URL!")
            return
        }
        
        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
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
                let newData = try decoder.decode(SquadJson.self, from: data)
                print("DATA:", newData.response?[0])
            } catch {
                print("error decoding")
            }
        }
        task.resume()
    }

    func loadSquads(teamId id: String) async {
        // https://v3.football.api-sports.io/players/squads?team=33
        guard let url = URL(string: "https://v3.football.api-sports.io/squads?team=\(id)") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
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
                let newData = try decoder.decode(SquadJson.self, from: data)
                print("DATA:", newData.response?[0])
            } catch {
                print("error decoding")
            }
        }
        task.resume()
    }
    

    func loadTeam(withId id: String) async {
        // https://v3.football.api-sports.io/teams?id=33
        guard let url = URL(string: "https://v3.football.api-sports.io/teams?id=\(id)") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
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
                let newData = try decoder.decode(TeamJson.self, from: data)
                print("DATA:", newData.response?[0])
            } catch {
                print("error decoding")
            }
        }
        task.resume()
    }
    
    func loadTeams(withLeagueId id: String, withSeasonId seasonId: String) async {
//        // https://v3.football.api-sports.io/teams?league=39&season=2023
//        guard let url = URL(string: "https://v3.football.api-sports.io/teams?league=\(id)&season=\(seasonId)") else {
//            print("Could not get URL!")
//            return
//        }
//
//        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
//        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
//        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
//        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else {
//              print("ERROR:", String(describing: error))
//              return
//            }
//            
//            // reference: https://developer.apple.com/documentation/foundation/jsondecoder
//            let decoder = JSONDecoder()
//            do {
//                let newData = try decoder.decode(TeamJson.self, from: data)
//                print("DATA:", newData.response?[0])
//            } catch {
//                print("error decoding")
//            }
//        }
//        task.resume()
    }
    
    func loadLeagues() async {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
//        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
//        var newData: LeagueJson = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
              print("ERROR:", String(describing: error))
              return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            // reference: https://developer.apple.com/documentation/foundation/jsondecoder
            let decoder = JSONDecoder()
            do {
                let newData = try decoder.decode(LeagueJson.self, from: data)
//                newData = try decoder.decode(LeagueJson.self, from: data)
                print("DATA:", newData.response![0])
//                return newData

            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func loadLeaguesFile() {
        
        guard let filePath = Bundle.main.path(forResource: "data/leagues", ofType: "json") else {
            return
        }
        
        guard let contentData = FileManager.default.contents(atPath: filePath) else {
            return
        }
        
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(LeagueJson.self, from: contentData)
//                newData = try decoder.decode(LeagueJson.self, from: data)
        print("DATA:", newData?.response!)
        
//        if let responses = newData?.response {
//            for response in responses {
//                print(response)
//            }
//        }
 
//        content = String(data: contentData, encoding: .utf8)
        
//        let fileURL = Bundle.main.url(forResource: "leagues", withExtension: "json")!
//        print(fileURL)
//        
//        let data1 = try? Data(contentsOf: fileURL)
//        print(data1)
//        
//        guard let url = URL(string: "/users/ethanrichards/Documents/footballviewer/data/leagues.json") else {
//            return
//        }
//        
//        let data = try? Data(contentsOf: url)
//        
//        print(data)
        
        
        
    }
    
}
