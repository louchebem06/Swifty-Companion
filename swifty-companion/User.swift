//
//  User.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

struct Version: Codable {
    let large: URL
    let medium: URL
    let small: URL
    let micro: URL
}

struct ImageProfil: Codable {
    let link: URL
    let versions: Version
}

struct Cursus: Codable {
	let id: Int
    let name: String
    let kind: String
}

struct Skill: Codable {
    let name: String
    let level: Double
}

struct SkillItem: Codable {
	let id: Int
	let slug: String
	let name: String
	let created_at: String
}

struct CursusUser: Codable {
	let id: Int
    let level: Double
    let cursus: Cursus
    var skills: [Skill]
    let grade: String?
}

struct Project: Codable {
	let id: Int
    let name: String
	let parent_id: Int?
}

struct ProjectsUser: Codable {
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let validated: Bool?
    let project: Project
    let marked: Bool
	let cursus_ids: [Int]
	let marked_at: String?
	let retriable_at: String?
	let created_at: String
	let updated_at: String
}

struct Coalition: Codable {
	let id: Int
	let name: String
	let image_url: URL
	let color: String
	let score: Int
}

struct User: Codable {
    var id: Int?
    var email: String?
    var login: String?
    var first_name: String?
    var last_name: String?
    var phone: String?
    var image: ImageProfil?
    var wallet: Int?
    var location: String?
    var correction_point: Int?
    var cursus_users: [CursusUser?]?
    var projects_users: [ProjectsUser?]?
	var coalitions: [Coalition?]?
}
