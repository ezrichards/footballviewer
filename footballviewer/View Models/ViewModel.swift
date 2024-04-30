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
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {

    // MARK: TODO check if all of these variables are used and clean up the data model
    let fileManager = FileManager.default
    let season = 2023 // MARK: TODO make this a variable within settings/preferences?
    @State var preferencesController = PreferencesController()
    @Published var leagueResp: LeagueJson?
    @Published var leagues: [League?] = []
    @Published var squads: SquadJson?
    @Published var selectedLeague: League? = nil {
        didSet {
            if let league = selectedLeague, let leagueId = league.id {
                loadTeams(leagueId: leagueId)
                preferencesController.lastLeague = leagueId
            }
        }
    }
    @Published var teamOnePlayers: [Players]?
    @Published var teamTwoPlayers: [Players]?
    @Published var teamOneSelection: Team? = nil {
        didSet {
            Task {
                teamOnePlayers = await loadSquad(teamId: teamOneSelection?.id ?? 0)
            }
        }
    }
    @Published var teamTwoSelection: Team? = nil {
        didSet {
            Task {
                teamTwoPlayers = await loadSquad(teamId: teamTwoSelection?.id ?? 0)
            }
        }
    }

    // selected 'detail view' player and associated data
    @Published var player: PlayerJson? = nil
    @Published var playerSelection: PlayerResponse.ID? = nil {
        didSet {
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

    // selected league info
    @Published var selectedLeagues: [League?] = []
    @Published var leagueSelection: Set<League.ID> = [] {
        didSet {
            var newLeagues: [League?] = []
            for league in leagues {
                for selection in leagueSelection {
                    if league?.id == selection && !newLeagues.contains(league) {
                        newLeagues.append(league)
                    }
                }
            }
            self.selectedLeagues = newLeagues
            
            self.teams = []
            for league in newLeagues {
                loadTeams(leagueId: league?.id ?? 0)
            }
        }
    }
    
    // selected team info
    @Published var teams: [SquadResponse] = []
    @Published var teamSelection: Set<SquadResponse.ID> = [] {
        didSet {
            print("didSet", teamSelection)
            
            // MARK: TODO populate teams with actual teams

        }
    }
    
    // players that will show up in the table
    private var loadedPlayers: [PlayerJson?] = []
    
    // selected players info (sidebar)
    @Published var players: [PlayerResponse]
    @Published var selectedPlayers: Set<PlayerResponse.ID> = [] {
        didSet {
            print("didSet")
            
//            for team in teams {
//                Task {
//                    var squadPlayers = await loadSquad(teamId: team.team?.id ?? 0)
//                    
//                    for player in squadPlayers {
//                        players.append(player)
//                    }
//                }
//            }

        }
    }
    
    init() {
        players = []
        
        loadLeaguesFromFile()
//        if let responses = leagueResp?.response {
//            for response in responses {
//                if let league = response.league {
//                    if league.id == preferencesController.lastLeague {
//                        selectedLeague = response.league
//                    }
//                }
//            }
//        }
//        loadTeams(leagueId: preferencesController.lastLeague)
        
        // MARK: TODO testing code only; query and cache all or most players
//        Task {
//            let p1 = await loadPlayerById(withId: 1485, withSeasonId: season)
//            let p2 = await loadPlayerById(withId: 37127, withSeasonId: season)
//            let p3 = await loadPlayerById(withId: 629, withSeasonId: season)
//
//            loadedPlayers.append(p1)
//            loadedPlayers.append(p2)
//            loadedPlayers.append(p3)
//
//            await MainActor.run {
//                if let p1 = p1, let resp = p1.response {
//                    players.append(resp[0])
//                }
//                
//                if let p2 = p2, let resp = p2.response {
//                    players.append(resp[0])
//                }
//                
//                if let p3 = p3, let resp = p3.response {
//                    players.append(resp[0])
//                }
//            }
//        }
        
        // MARK: TODO check that file exists for loadLeaguesFromFile
        // MARK: TODO load teams from file, load players from file
        
    }

    func loadPlayerById(withId id: Int, withSeasonId seasonId: Int) async -> PlayerJson? {
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
                return newData
            } catch {
                print("Error decoding squad:", error)
            }
        } catch {
            print("Error with URLSession:", error)
        }
        return nil
    }

    func loadSquad(teamId id: Int) async -> [Players] {
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
                return newData.response?.first?.players ?? []
            } catch {
                print("Error decoding squad:", error)
            }
        } catch {
            print("Error with URLSession:", error)
        }
        return []
    }

    func loadTeams(withLeagueId id: Int, withSeasonId seasonId: Int) async {
        // MARK: TODO clean this function up
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let documentURL = appSupportURL.appendingPathComponent("teams-\(id).json")
        
//        print("ABS:", documentURL.path)
        
        if fileManager.fileExists(atPath: documentURL.path) {
            print("Team file exists, loading from cached file..")
            
            Task {
                await loadTeamsByLeagueFromFile(withLeagueId: id)
            }
        }
        else {
            print("Team file does not exist, querying..")
            
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
                    
//                    print(newData)
                    
                    // MARK: APP SUPPORT STUFF
                    let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                    let documentURL = appSupportURL.appendingPathComponent("teams-\(id).json")
    
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
                    
                    // MARK: returning stuff
                    await MainActor.run {
                        //                    self.squads = newData
                        
                        // MARK: TODO new teams code
                        if let resp = newData.response {
                            for response in resp {
                                if !teams.contains(where: { $0.id == response.id }) {
                                    self.teams.append(response)
                                    //                                print("ADDED \(response)")
                                }
                            }
                        }
                        //                    self.teams.append(newData.response?[0])
                        
                    }
                } catch {
                    print("Error decoding squad:", error)
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
                
                await MainActor.run {
                    if let response = newData.response {
                        for resp in response {
                            self.leagues.append(resp.league)
                        }
                    }
                }
            } catch {
                print("Error decoding squad:", error)
            }
        } catch {
            print("Error with URLSession:", error)
        }
    }
    
    func loadLeaguesFromFile() {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
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
        self.leagueResp = newData
    }
    
    func loadTeamsByLeagueFromFile(withLeagueId leagueId: Int) async {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let documentURL = appSupportURL.appendingPathComponent("teams-\(leagueId).json")
        
        guard let contentData = try? Data(contentsOf: documentURL) else {
            print("Error opening file at:", documentURL.description)
            return
        }
        
        let decoder = JSONDecoder()
        let newData = try? decoder.decode(SquadJson.self, from: contentData)
        
        if let newData = newData, let response = newData.response {
            for resp in response {
//                print("LOADING TEAM \(resp)")
                await MainActor.run {
                    self.teams.append(resp)
                }
            }
        }
    }
    
    
    func loadTeams(leagueId: Int) {
        Task {
            await loadTeams(withLeagueId: leagueId, withSeasonId: season)
        }
    }
}
