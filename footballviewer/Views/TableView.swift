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
    
    @Binding var sortOrder: [KeyPathComparator<PlayerResponse>]
    
    var body: some View {
        VSplitView {
            Table(players, selection: $selection, sortOrder: $sortOrder) {
                Group {
                    TableColumn("Name", value: \.player.name) { (player: PlayerResponse) in
                        Text(player.player.name)
                    }
                    
                    TableColumn("Age", value: \.player.age) { (player: PlayerResponse) in
                        Text(String(player.player.age))
                    }

                    TableColumn("Position", value: \.statistics[0].games.position) { (player: PlayerResponse) in
                        Text(String(describing: player.statistics[0].games.position))
                    }
                    
                    TableColumn("Appearances", value: \.statistics[0].games.appearences) { (player: PlayerResponse) in
                        Text(String(describing: player.statistics[0].games.appearences))
                    }
                    
                    TableColumn("Goals", value: \.statistics[0].goals.total) {
                        Text(String(describing: $0.statistics[0].goals.total))
                    }
                    
                    TableColumn("Assists", value: \.statistics[0].goals.assists) {
                        Text(String(describing: $0.statistics[0].goals.assists))
                    }
                    
                    TableColumn("Successful Dribbles", value: \.statistics[0].dribbles.success) {
                        Text(String(describing: $0.statistics[0].dribbles.success))
                    }
    
                    TableColumn("Total shots", value: \.statistics[0].shots.total) {
                        Text(String(describing: $0.statistics[0].shots.total))
                    }
                }
                
                Group {
                    TableColumn("Shots on target", value: \.statistics[0].shots.on) { (player: PlayerResponse) in
                        Text(String(describing: player.statistics[0].shots.on))
                    }
                    
                    TableColumn("Total passes", value: \.statistics[0].passes.total) {
                        Text(String(describing: $0.statistics[0].passes.total))
                    }
                    
                    TableColumn("Key passes", value: \.statistics[0].passes.key) {
                        Text(String(describing: $0.statistics[0].passes.key))
                    }
                    
                    TableColumn("Tackles", value: \.statistics[0].tackles.total) {
                        Text(String(describing: $0.statistics[0].tackles.total))
                    }
                    
                    TableColumn("Blocks", value: \.statistics[0].tackles.blocks) {
                        Text(String(describing: $0.statistics[0].tackles.blocks))
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 400)
        }
        .frame(maxWidth: .infinity)
    }
}
