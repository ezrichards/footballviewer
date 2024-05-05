//
//  ViewModel.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/1/24.
//
//  References Used In File:
//  https://www.api-football.com/documentation-v3#section/Sample-Scripts/Swift
//  https://stackoverflow.com/questions/35272712/where-do-i-specify-reloadignoringlocalcachedata-for-nsurlsession-in-swift-2
//  https://developer.apple.com/documentation/foundation/filemanager/1410277-fileexists
//  https://stackoverflow.com/questions/42897844/swift-3-0-filemanager-fileexistsatpath-always-return-false
//  https://stackoverflow.com/questions/34161786/reduce-array-to-set-in-swift
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    
    var season = 2023
    
    @State var preferencesController = PreferencesController()

    @Published var player: PlayerJson? = nil
    
    @Published var playerSelection: PlayerResponse.ID? = nil {
        didSet {
            if playerSelection == nil {
                player = nil
            }
            
            for player in loadedPlayers {
                if let player = player, let resp = player.response {
                    for playerResp in resp {
                        if playerResp.id == playerSelection {
                            self.player = player
                        }
                    }
                }
            }
        }
    }
    
    @Published var leagues: [League?] = []
    
    @Published var leagueSelection: Set<League.ID> = [] {
        didSet {
            // debounce (maybe bad practice)
            if leagueSelection == oldValue {
                return
            }

            var newLeagues: [League?] = []
            for league in leagues {
                for selection in leagueSelection {
                    if league?.id == selection && !newLeagues.contains(league) {
                        newLeagues.append(league)
                    }
                }
            }

            self.teams = []
            for league in newLeagues {
                loadTeams(leagueId: league?.id ?? 0)
            }
            preferencesController.lastLeagues = Array(leagueSelection)
        }
    }
    
    // players that will show up in the table
    private var loadedPlayers: [PlayerJson?] = []
    @Published var selectedPlayersTable: [PlayerResponse]
    
    // selected players info (sidebar)
    @Published var players: [PlayerResponse] = []
    @Published var selectedPlayers: Set<PlayerResponse.ID> = [] {
        didSet {
            self.selectedPlayersTable = []
            for player in players {
                for playerID in selectedPlayers {
                    if player.id == playerID {
                        self.selectedPlayersTable.append(player)
                    }
                }
            }
        }
    }
    
    @Published var sortOrder: [KeyPathComparator<PlayerResponse>] = [.init(\PlayerResponse.player.name, order: .forward), .init(\PlayerResponse.player.age, order: .forward), .init(\PlayerResponse.statistics[0].games.position, order: .forward), .init(\PlayerResponse.statistics[0].games.appearences, order: .forward), .init(\PlayerResponse.statistics[0].games.appearences, order: .forward), .init(\PlayerResponse.statistics[0].goals.total, order: .forward), .init(\PlayerResponse.statistics[0].goals.assists, order: .forward), .init(\PlayerResponse.statistics[0].dribbles.success, order: .forward), .init(\PlayerResponse.statistics[0].shots.total, order: .forward), .init(\PlayerResponse.statistics[0].shots.on, order: .forward), .init(\PlayerResponse.statistics[0].passes.total, order: .forward), .init(\PlayerResponse.statistics[0].passes.key, order: .forward), .init(\PlayerResponse.statistics[0].tackles.total, order: .forward), .init(\PlayerResponse.statistics[0].tackles.blocks, order: .forward), .init(\PlayerResponse.statistics[0].tackles.interceptions, order: .forward)] {
        didSet {
            self.selectedPlayersTable.sort(using: sortOrder)
        }
    }
    
    // selected team info
    @Published var teams: [SquadResponse] = []
    @Published var teamSelection: Set<SquadResponse.ID> = [] {
        didSet {
            for teamUUID in teamSelection {
                for team in teams {
                    if team.id == teamUUID {
                        Task {
                            let squadPlayers = await loadSquad(teamId: team.team?.id ?? 0)

                            await MainActor.run {
                                self.players = []
                            }

                            for player in squadPlayers {
                                let playerResp = await loadPlayerById(withId: player.id ?? 0, withSeasonId: season)
                                
                                if let resp = playerResp?.response {
                                    for response in resp {
                                        await MainActor.run {
                                            self.players.append(response)
                                        }
                                    }
                                }
                                loadedPlayers.append(playerResp)
                            }
                        }
                    }
                }
            }
        }
    }
    
    init() {
        selectedPlayersTable = []
        
        season = preferencesController.season
        
        loadLeaguesFromFile()
        
        // restore last leagues selected
//        leagueSelection = Set(preferencesController.lastLeagues.map { $0 })
    }

    /// Saves data to a given file by name in application support
    func cacheData<T: Encodable>(fileName: String, data: T) {
        let documentURL = appSupportURL.appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            do {
                try encodedData.write(to: documentURL)
            }
            catch {
                print("Error while writing encoded data:", error)
            }
        } catch {
            print("Error encoding data to \(fileName):", error)
        }
    }

    func loadPlayerById(withId id: Int, withSeasonId seasonId: Int) async -> PlayerJson? {
        let documentURL = appSupportURL.appendingPathComponent("player-\(id).json")
        
        if FileManager.default.fileExists(atPath: documentURL.path) {
            return loadPlayerByIdFromFile(withId: id)
        }
        else {
            // https://v3.football.api-sports.io/players?id=909&season=2023
            guard let url = URL(string: "https://v3.football.api-sports.io/players?id=\(id)&season=\(seasonId)") else {
                print("Could not get URL!")
                return nil
            }
            
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
            request.httpMethod = "GET"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                do {
                    let newData = try decoder.decode(PlayerJson.self, from: data)
                    cacheData(fileName: "player-\(id).json", data: newData)
                    return newData
                } catch {
                    print("Error decoding player by id \(id):", error)
                }
            } catch {
                print("Error with URLSession:", error)
            }
        }
        return nil
    }

    func loadSquad(teamId id: Int) async -> [Players] {
        let documentURL = appSupportURL.appendingPathComponent("players-\(id).json")

        if FileManager.default.fileExists(atPath: documentURL.path) {
            return loadPlayersByTeamFromFile(withTeamId: id)
        }
        else {
            // https://v3.football.api-sports.io/players/squads?team=33
            guard let url = URL(string: "https://v3.football.api-sports.io/players/squads?team=\(id)") else {
                print("Could not get URL!")
                return []
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
            request.httpMethod = "GET"
            request.cachePolicy = .reloadIgnoringLocalCacheData

            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                do {
                    let newData = try decoder.decode(SquadJson.self, from: data)
                    cacheData(fileName: "players-\(id).json", data: newData)
                    return newData.response?.first?.players ?? []
                } catch {
                    print("Error decoding squad:", error)
                }
            } catch {
                print("Error with URLSession:", error)
            }
        }
        return []
    }

    func loadTeams(withLeagueId id: Int, withSeasonId seasonId: Int) async {
        let documentURL = appSupportURL.appendingPathComponent("teams-\(id).json")

        if FileManager.default.fileExists(atPath: documentURL.path) {
            Task {
                await loadTeamsByLeagueFromFile(withLeagueId: id)
            }
        }
        else {
            // https://v3.football.api-sports.io/teams?league=39&season=2023
            guard let url = URL(string: "https://v3.football.api-sports.io/teams?league=\(id)&season=\(seasonId)") else {
                print("Could not get URL!")
                return
            }
            
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
            request.httpMethod = "GET"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                do {
                    let newData = try decoder.decode(SquadJson.self, from: data)
                    cacheData(fileName: "teams-\(id).json", data: newData)

                    await MainActor.run {
                        if let resp = newData.response {
                            for response in resp {
                                if !teams.contains(where: { $0.id == response.id }) {
                                    self.teams.append(response)
                                }
                            }
                        }
                    }
                } catch {
                    print("Error decoding teams:", error)
                }
            } catch {
                print("Error with URLSession:", error)
            }
        }
    }

    func loadLeagues() async {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Could not get URL!")
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(preferencesController.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            do {
                let newData = try decoder.decode(LeagueJson.self, from: data)
                cacheData(fileName: "leagues.json", data: newData)

                await MainActor.run {
                    if let response = newData.response {
                        for resp in response {
                            self.leagues.append(resp.league)
                        }
                    }
                }
            } catch {
                print("Error decoding leagues:", error)
            }
        } catch {
            print("Error with URLSession:", error)
        }
    }
    
    func loadLeaguesFromFile() {
        let documentURL = appSupportURL.appendingPathComponent("leagues.json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return
        }
        
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(LeagueJson.self, from: contentData)
        
        if let newData = newData, let response = newData.response {
            for resp in response {
                self.leagues.append(resp.league)
            }
        }
    }
    
    func loadTeamsByLeagueFromFile(withLeagueId leagueId: Int) async {
        let documentURL = appSupportURL.appendingPathComponent("teams-\(leagueId).json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return
        }
        
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(SquadJson.self, from: contentData)
        
        if let newData = newData, let response = newData.response {
            for resp in response {
                await MainActor.run {
                    self.teams.append(resp)
                }
            }
        }
    }
    
    func loadPlayersByTeamFromFile(withTeamId teamId: Int) -> [Players] {
        let documentURL = appSupportURL.appendingPathComponent("players-\(teamId).json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return []
        }
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(SquadJson.self, from: contentData)

        return newData?.response?.first?.players ?? []
    }
    
    func loadPlayerByIdFromFile(withId id: Int) -> PlayerJson? {
        let documentURL = appSupportURL.appendingPathComponent("player-\(id).json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return nil
        }
        let decoder = JSONDecoder()
        
        do {
            let newData = try decoder.decode(PlayerJson.self, from: contentData)
            return newData
        }
        catch {
            print("Error decoding player \(id) from file:", error)
        }
        return nil
    }
    
    func loadTeams(leagueId: Int) {
        Task {
            await loadTeams(withLeagueId: leagueId, withSeasonId: season)
        }
    }
}
