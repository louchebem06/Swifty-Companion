//
//  User.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

/*
 https://api.intra.42.fr/apidoc/2.0/users/show.html
 - skill, level and percent
 - project completed and fail
*/

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
}

struct CursusUser: Codable {
    let level: Int
//    let skills: [Any]
    let cursus: Cursus
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
    //var cursus_users: [CursusUser?]?
}
