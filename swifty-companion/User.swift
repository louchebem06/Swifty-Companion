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

struct Image: Codable {
    let link: URL
    let versions: Version
}

struct Cursus: Codable {
    let name: String
    let kind: String
}

struct Skill: Codable {
    let name: String
    let level: Double
}

struct CursusUser: Codable {
    let level: Double
    let cursus: Cursus
    let skills: [Skill]
    let grade: String?
}

struct Project: Codable {
    let name: String
}

struct ProjectsUser: Codable {
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let validated: Bool?
    let project: Project
    let marked: Bool
}

struct User: Codable {
    var id: Int?
    var email: String?
    var login: String?
    var first_name: String?
    var last_name: String?
    var phone: String?
    var image: Image?
    var wallet: Int?
    var location: String?
    var correction_point: Int?
    var cursus_users: [CursusUser?]?
    var projects_users: [ProjectsUser?]?
}
