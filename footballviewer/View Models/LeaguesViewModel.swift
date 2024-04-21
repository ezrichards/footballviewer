//
//  LeaguesViewModel.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/14/24.
//

import Foundation
import SwiftUI

class LeaguesViewModel: ObservableObject {
    
    let season = 2023
    @State var viewModel = ViewModel()
    @State var preferencesController = PreferencesController()
    
    @Published var selectedLeague: League? = nil {
        didSet {
            if let league = selectedLeague, let leagueId = league.id {
                Task {
                    await viewModel.loadTeams(withLeagueId: leagueId, withSeasonId: season)
                }
                preferencesController.lastLeague = leagueId
            }
        }
    }
    
    init() {
        if let leagues = viewModel.leagues, let responses = leagues.response {
            for response in responses {
                if let league = response.league {
                    if league.id == preferencesController.lastLeague {
                        selectedLeague = response.league
                    }
                }
            }
        }
    }
    
    func updateSelection(newSelection: League?) {
        selectedLeague = newSelection
    }
}
