//
//  TableView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/26/24.
//  References: https://stackoverflow.com/questions/69874420/macos-swiftui-table-with-more-than-10-columns
//

import SwiftUI

struct TableView: View {
    
    var players: [PlayerResponse]
    
    var body: some View {
        VSplitView {
            Text("Select players?")
                .frame(maxWidth: .infinity, minHeight: 500)

            Table(players) {
                Group {
                    TableColumn("Name", value: \PlayerResponse.player.name!)
                    TableColumn("Age") {
                        Text(String(describing: $0.player.age!))
                    }
                    
                    TableColumn("Position") {
                        Text(String(describing: $0.statistics?[0].games?.position ?? ""))
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
                    TableColumn("Shots on target") { (player: PlayerResponse) in // this is odd
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
