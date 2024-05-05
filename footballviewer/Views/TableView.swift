//
//  TableView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/26/24.
//  References: https://stackoverflow.com/questions/69874420/macos-swiftui-table-with-more-than-10-columns
//  https://www.swiftyplace.com/blog/chy7hvne
//  https://stackoverflow.com/questions/74339012/change-of-selected-row-in-table-for-macos
//

import SwiftUI

struct TableView: View {
    var viewModel: ViewModel
    
    var players: [PlayerResponse]

    @Binding var selection: PlayerResponse.ID?
    
    @State private var sortOrder: [KeyPathComparator<PlayerResponse>] = [.init(\PlayerResponse.player.name)]
    
    var body: some View {
        VSplitView {
            Table(players, selection: $selection) {
                Group {
                    TableColumn("Name") { (player: PlayerResponse) in
                        Text(player.player.name ?? "")
                    }
                    
                    TableColumn("Age") {
                        Text(String(describing: $0.player.age ?? 0))
                    }

                    TableColumn("Position") {
                        Text(String(describing: $0.statistics?[0].games?.position ?? ""))
                    }
                    
                    TableColumn("Appearances") {
                        Text(String(describing: $0.statistics?[0].games?.appearences ?? 0))
                    }
                    
                    TableColumn("Goals") {
                        Text(String(describing: $0.statistics?[0].goals?.total ?? 0))
                    }
                    
                    TableColumn("Assists") {
                        Text(String(describing: $0.statistics?[0].goals?.assists ?? 0))
                    }
                    
                    TableColumn("Successful Dribbles") {
                        Text(String(describing: $0.statistics?[0].dribbles?.success ?? 0))
                    }
                    
                    TableColumn("Total shots") {
                        Text(String(describing: $0.statistics?[0].shots?.total ?? 0))
                    }
                }
                
                Group {
                    TableColumn("Shots on target") { (player: PlayerResponse) in
                        Text(String(describing: player.statistics?[0].shots?.on ?? 0))
                    }
                    
                    TableColumn("Total passes") {
                        Text(String(describing: $0.statistics?[0].passes?.total ?? 0))
                    }
                    
                    TableColumn("Key passes") {
                        Text(String(describing: $0.statistics?[0].passes?.key ?? 0))
                    }
                    
                    TableColumn("Tackles") {
                        Text(String(describing: $0.statistics?[0].tackles?.total ?? 0))
                    }
                    
                    TableColumn("Blocks") {
                        Text(String(describing: $0.statistics?[0].tackles?.blocks ?? 0))
                    }
                    
                    TableColumn("Interceptions") {
                        Text(String(describing: $0.statistics?[0].tackles?.interceptions ?? 0))
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 400)
        }
        .frame(maxWidth: .infinity)
    }
}
