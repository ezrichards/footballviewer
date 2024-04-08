/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Coverage : Codable {
	let fixtures : Fixtures?
	let standings : Bool?
	let players : Bool?
	let top_scorers : Bool?
	let top_assists : Bool?
	let top_cards : Bool?
	let injuries : Bool?
	let predictions : Bool?
	let odds : Bool?

	enum CodingKeys: String, CodingKey {

		case fixtures = "fixtures"
		case standings = "standings"
		case players = "players"
		case top_scorers = "top_scorers"
		case top_assists = "top_assists"
		case top_cards = "top_cards"
		case injuries = "injuries"
		case predictions = "predictions"
		case odds = "odds"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fixtures = try values.decodeIfPresent(Fixtures.self, forKey: .fixtures)
		standings = try values.decodeIfPresent(Bool.self, forKey: .standings)
		players = try values.decodeIfPresent(Bool.self, forKey: .players)
		top_scorers = try values.decodeIfPresent(Bool.self, forKey: .top_scorers)
		top_assists = try values.decodeIfPresent(Bool.self, forKey: .top_assists)
		top_cards = try values.decodeIfPresent(Bool.self, forKey: .top_cards)
		injuries = try values.decodeIfPresent(Bool.self, forKey: .injuries)
		predictions = try values.decodeIfPresent(Bool.self, forKey: .predictions)
		odds = try values.decodeIfPresent(Bool.self, forKey: .odds)
	}

}