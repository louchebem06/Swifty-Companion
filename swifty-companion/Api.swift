//
//  Api.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

class Api {
    static private let grant_type: String = "authorization_code";
    static private var secret: String = "";
    static private var token: Token = Token();
    
    static public let baseUrl: String = "https://api.intra.42.fr";
    static public let redirect_uri: String = "swifty-companion://auth";
    static public var uid: String = "";
    
    public static func setSecret(_ secret: String) -> Void { Api.secret = secret; }
    public static func setUID(_ uid: String) -> Void { Api.uid = uid; }
    public static func setToken(_ token: Token) -> Void { Api.token = token; }

    public static func getValue(_ apiUrl: String) async -> String {
        do {
            let url: URL = URL(string: "\(Api.baseUrl)\(apiUrl)")!;
            var request = URLRequest(url: url);
            request.httpMethod = "GET";
            request.setValue("\(Api.token.token_type!) \(Api.token.access_token!)", forHTTPHeaderField: "Authorization");
            let (data, _) = try await URLSession.shared.data(for: request);
            let jsonString = String(data: data, encoding: .utf8)!;
            return (jsonString);
        } catch {
            fatalError("Error get value");
        }
    }
    
    public static func codeToToken(_ code: String) async -> Token {
        let url: URL = URL(string: "https://api.intra.42.fr/oauth/token")!;
        let oauth: [String: String] = [
            "grant_type": Api.grant_type,
            "client_id": Api.uid,
            "client_secret": Api.secret,
            "code": code,
            "redirect_uri": Api.redirect_uri
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: oauth)
            var request = URLRequest(url: url);
            request.httpMethod = "POST";
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData;
            let (data, _) = try await URLSession.shared.data(for: request);
            let values: String = String(data: data, encoding: .utf8)!;
            let jsonToken = values.data(using: .utf8)!;
            let newToken: Token = try JSONDecoder().decode(Token.self, from: jsonToken);
            Api.token = newToken;
            return (newToken);
        } catch {
            fatalError("Error request Token");
        }
    }
}
