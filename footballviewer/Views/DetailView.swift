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
            VStack {
                if let photo = response.player.photo {
                    AsyncImage(url: URL(string: photo)) { image in
                        image
                    } placeholder: {
                        ProgressView()
                    }
                }

                ScrollView {
                    Text("\(response.player.name)").bold()
                    Text("Age: \(response.player.age)")
                    Text("Nationality: \(response.player.nationality ?? "")")
                    
                    Spacer()
                    
                    let statistic = response.statistics.first(where: { viewModel.leagueSelection.contains($0.league?.id) })
                    
                    Text("General Statistics").bold()
                    Text("Appearances: \(statistic?.games.appearences ?? 0)")
                    
                    let rating = String(format: "%.2f", Float(statistic?.games.rating ?? "N/A") ?? 0.0)
                    
                    Text("Average Rating: \(rating)")
                    Text("Position: \(statistic?.games.position ?? "N/A")")
                    
                    Spacer()
                    
                    Text("Goals/Assists").bold()
                    Text("Goals: \(statistic?.goals.total ?? 0)")
                    Text("Assists: \(statistic?.goals.assists ?? 0)")
                    
                    Spacer()
                    
                    Text("Passes").bold()
                    Text("Total: \(statistic?.passes.total ?? 0)")
                    Text("Key Passes: \(statistic?.passes.key ?? 0)")
                    Text("Accuracy: \(statistic?.passes.accuracy ?? 0)%")
                    
                    Spacer()
                    
                    Text("Defensive Actions").bold()
                    Text("Tackles: \(statistic?.tackles.total ?? 0)")
                    Text("Blocks: \(statistic?.tackles.blocks ?? 0)")
                    Text("Interceptions: \(statistic?.tackles.interceptions ?? 0)")
                }
            }
        } else {
            Text("No player selected!")
                .padding()
        }
    }
}
