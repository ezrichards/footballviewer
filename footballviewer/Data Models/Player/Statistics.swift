/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Statistics : Codable, Identifiable {
    let id = UUID()
	let team : Team?
	let league : League?
	let games : Games?
	let substitutes : Substitutes?
	let shots : Shots?
	let goals : Goals?
	let passes : Passes?
	let tackles : Tackles?
	let duels : Duels?
	let dribbles : Dribbles?
	let fouls : Fouls?
	let cards : Cards?
	let penalty : Penalty?

	enum CodingKeys: String, CodingKey {

		case team = "team"
		case league = "league"
		case games = "games"
		case substitutes = "substitutes"
		case shots = "shots"
		case goals = "goals"
		case passes = "passes"
		case tackles = "tackles"
		case duels = "duels"
		case dribbles = "dribbles"
		case fouls = "fouls"
		case cards = "cards"
		case penalty = "penalty"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		team = try values.decodeIfPresent(Team.self, forKey: .team)
		league = try values.decodeIfPresent(League.self, forKey: .league)
		games = try values.decodeIfPresent(Games.self, forKey: .games)
		substitutes = try values.decodeIfPresent(Substitutes.self, forKey: .substitutes)
		shots = try values.decodeIfPresent(Shots.self, forKey: .shots)
		goals = try values.decodeIfPresent(Goals.self, forKey: .goals)
		passes = try values.decodeIfPresent(Passes.self, forKey: .passes)
		tackles = try values.decodeIfPresent(Tackles.self, forKey: .tackles)
		duels = try values.decodeIfPresent(Duels.self, forKey: .duels)
		dribbles = try values.decodeIfPresent(Dribbles.self, forKey: .dribbles)
		fouls = try values.decodeIfPresent(Fouls.self, forKey: .fouls)
		cards = try values.decodeIfPresent(Cards.self, forKey: .cards)
		penalty = try values.decodeIfPresent(Penalty.self, forKey: .penalty)
	}

}
