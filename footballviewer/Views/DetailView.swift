//
//  DetailView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/28/24.
//

import SwiftUI

struct DetailView: View {
    var viewModel: ViewModel
    
    var player: PlayerJson?
    
    var body: some View {
        if let playerOne = player, let response = playerOne.response?.first, let statistics = response.statistics {

            if let photo = response.player.photo {
                AsyncImage(url: URL(string: photo))
                Text("\(response.player.name!)")
                Text("Age: \(response.player.age!)")
                Text("Nationality: \(response.player.nationality!)")
            }
            
            ForEach(statistics) { statistic in
                if viewModel.leagueSelection.contains(statistic.league?.id) {
                    ScrollView {
                        Text("General Statistics").bold()
                        if let games = statistic.games, let rating = games.rating, let appearances = games.appearences, let position = games.position {
                            Text("Appearances: \(appearances)")
                            Text("Average Rating: \(rating)")
                            Text("Position: \(position)")
                        }
                        Spacer()
                        
                        Text("Goals/Assists").bold()
                        if let goals = statistic.goals, let total = goals.total, let assists = goals.assists {
                            Text("Goals: \(total)")
                            Text("Assists: \(assists)")
                        }
                        Spacer()
                        
                        Text("Passes").bold()
                        if let passes = statistic.passes, let total = passes.total, let key = passes.key, let accuracy = passes.accuracy {
                            Text("Total: \(total)")
                            Text("Key Passes: \(key)")
                            Text("Accuracy: \(accuracy)%")
                        }
                    }
                }
            }
        } else {
            Text("No player selected!")
                .padding()
        }
    }
}
