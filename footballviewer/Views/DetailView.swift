//
//  DetailView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/28/24.
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-allow-row-selection-in-a-list
//

import SwiftUI

struct DetailView: View {
    var viewModel: ViewModel
    
    var player: PlayerJson?
    
    var body: some View {
        if let playerOne = player, let response = playerOne.response?.first {

            if let photo = response.player.photo {
                AsyncImage(url: URL(string: photo)) { image in
                    image
                } placeholder: {
                    ProgressView()
                }
            }
            
            ScrollView {
                VStack {
                    Text("\(response.player.name)").bold()
                    Text("Age: \(response.player.age)")
                    Text("Nationality: \(response.player.nationality ?? "")")
                }
                
                Spacer()
                
                ForEach(response.statistics) { statistic in
                    if viewModel.leagueSelection.contains(statistic.league?.id) {
                            Text("General Statistics").bold()
                            Text("Appearances: \(statistic.games.appearences)")
                            Text("Average Rating: \(statistic.games.rating)")
                            Text("Position: \(statistic.games.position)")

                            Spacer()
                            
                            Text("Goals/Assists").bold()
                            Text("Goals: \(statistic.goals.total)")
                            Text("Assists: \(statistic.goals.assists)")
                            Spacer()
                            
                            Text("Passes").bold()
                            Text("Total: \(statistic.passes.total)")
                            Text("Key Passes: \(statistic.passes.key)")
                            Text("Accuracy: \(statistic.passes.accuracy)%")
                        }
                    }
            }
        } else {
            Text("No player selected!")
                .padding()
        }
    }
}
