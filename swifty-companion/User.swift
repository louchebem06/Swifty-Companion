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

struct User: Codable {
    var id: Int?
    var email: String?
    var login: String?
    var first_name: String?
    var last_name: String?
    var phone: String?
    var image: Image?
}
