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
	static private let limitRate: Int = 2;
	static private var nbOfRequest: Int = 0;
    
    static public let baseUrl: String = "https://api.intra.42.fr";
    static public let redirect_uri: String = "swifty-companion://auth";
    static public var uid: String = "";
    
    public static func setSecret(_ secret: String) -> Void { Api.secret = secret; }
    public static func setUID(_ uid: String) -> Void { Api.uid = uid; }
    public static func setToken(_ token: Token) -> Void { Api.token = token; }
	
	static private func tokenIsValid() -> Bool {
		return !((Double(Api.token.created_at! + Api.token.expires_in!) - NSDate().timeIntervalSince1970) < 10)
	}

    public static func getValue(_ apiUrl: String) async -> String {
		if (tokenIsValid()) {
			do {
				if (nbOfRequest == limitRate) {
					sleep(1);
					nbOfRequest = 0;
				}
				nbOfRequest += 1;
				let url: URL? = URL(string: "\(Api.baseUrl)\(apiUrl)");
				if (url == nil) {
					return ("");
				}
				var request = URLRequest(url: url!);
				request.httpMethod = "GET";
				request.setValue("\(Api.token.token_type!) \(Api.token.access_token!)", forHTTPHeaderField: "Authorization");
				let (data, _) = try await URLSession.shared.data(for: request);
				let jsonString = String(data: data, encoding: .utf8)!;
				return (jsonString);
			} catch {
				return ("");
			}
		}
		await refreshToken();
		return (await getValue(apiUrl));
    }
    
	public static func codeToToken(_ code: String) async -> Token {
        let url: URL = URL(string: "https://api.intra.42.fr/oauth/token")!;
        let oauth: [String: String] = [
            "grant_type": Api.grant_type,
            "client_id": Api.uid,
            "client_secret": Api.secret,
            "code": code,
            "redirect_uri": Api.redirect_uri
		];
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
			let db = CoreData();
			db.insert(Api.token);
            return (newToken);
        } catch {
            fatalError("Error request Token");
        }
    }
	
	private static func refreshToken() async -> Void {
		let url: URL = URL(string: "https://api.intra.42.fr/oauth/token")!;
		let oauth: [String: String] = [
			"grant_type": "refresh_token",
			"client_id": Api.uid,
			"client_secret": Api.secret,
			"refresh_token": Api.token.refresh_token!,
			"redirect_uri": Api.redirect_uri
		];
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
			let db = CoreData();
			db.insert(Api.token);
		} catch {
			fatalError("Error request Token");
		}
	}
}
