//
//  Token.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

struct Token: Codable {
    var scope: String?
    var access_token: String?
    var refresh_token: String?
    var token_type: String?
    var expires_in: Int?
    var created_at: Int?
}
