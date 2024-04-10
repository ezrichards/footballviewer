/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Player : Codable {
	let id : Int?
	let name : String?
	let firstname : String?
	let lastname : String?
	let age : Int?
	let birth : Birth?
	let nationality : String?
	let height : String?
	let weight : String?
	let injured : Bool?
	let photo : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case firstname = "firstname"
		case lastname = "lastname"
		case age = "age"
		case birth = "birth"
		case nationality = "nationality"
		case height = "height"
		case weight = "weight"
		case injured = "injured"
		case photo = "photo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
		lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
		age = try values.decodeIfPresent(Int.self, forKey: .age)
		birth = try values.decodeIfPresent(Birth.self, forKey: .birth)
		nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
		height = try values.decodeIfPresent(String.self, forKey: .height)
		weight = try values.decodeIfPresent(String.self, forKey: .weight)
		injured = try values.decodeIfPresent(Bool.self, forKey: .injured)
		photo = try values.decodeIfPresent(String.self, forKey: .photo)
	}

}