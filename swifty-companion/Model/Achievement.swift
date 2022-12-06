//
//  Achivement.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 06/12/2022.
//

import Foundation

struct AchievementUserItem: Codable {
	let achievement_id: Int
	let nbr_of_success: Int?
}

struct Achievement: Codable {
	let id: Int
	let name: String
	let description: String
	let visible: Bool?
	let image: String?
	let nbr_of_success: Int?
}
