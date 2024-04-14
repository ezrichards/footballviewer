//
//  ViewModel.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/1/24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {

    @State var preferencesController = PreferencesController()

    @Published var leagues: LeagueJson?
    @Published var squads: SquadJson?
    
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
    
    func loadTeams(withLeagueId id: Int, withSeasonId seasonId: Int) async {
        // https://v3.football.api-sports.io/teams?league=39&season=2023
        guard let url = URL(string: "https://v3.football.api-sports.io/teams?league=\(id)&season=\(seasonId)") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData

        print("RUN REQUEST")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
              print("ERROR:", String(describing: error))
              return
            }
            
            print("RAN DATATASK")
            
            // reference: https://developer.apple.com/documentation/foundation/jsondecoder
            let decoder = JSONDecoder()
            do {
                let newData = try decoder.decode(TeamJson.self, from: data)
//                print("DATA:", newData.response?[0])
                
                print("TEST:")
                for response in newData.response! {
                    print(response)
                }
                
//                self.squads = newData.response?[0]
                
            } catch {
                print("error decoding")
            }
        }
        task.resume()
    }
    
    func loadLeagues() async {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Could not get URL!")
            return
        }

        // reference: https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
        // reference: https://stackoverflow.com/questions/35272712/where-do-i-specify-reloadignoringlocalcachedata-for-nsurlsession-in-swift-2
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
              print("ERROR:", String(describing: error))
              return
            }
            
            // reference: https://developer.apple.com/documentation/foundation/jsondecoder
            let decoder = JSONDecoder()
            do {
                let newData = try decoder.decode(LeagueJson.self, from: data)

                // MARK: APP SUPPORT STUFF
                let fileManager = FileManager.default
                let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                let documentURL = appSupportURL.appendingPathComponent("leagues.json")
                
                let encoder = JSONEncoder()
                do {
                    let encodedData = try encoder.encode(newData)
                    do {
                        try encodedData.write(to: documentURL)
                    }
                    catch {
                        print("error while writing encoded data: ", error)
                    }
                }
                catch {
                    print("error while encoding data:", error)
                }
            } catch {
                print("error writing: ", error)
            }
        }
        task.resume()
    }
    
    func loadLeaguesFromFile() {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let documentURL = appSupportURL.appendingPathComponent("leagues.json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return
        }
        
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(LeagueJson.self, from: contentData)
        self.leagues = newData
    }
}
