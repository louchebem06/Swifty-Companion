//
//  Api.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

func codeToToken(_ client_id: String,_ client_secret: String,_ code: String) async -> Dictionary<String, Any> {
    let grant_type: String = "authorization_code";
    let redirect_uri: String = "swifty-companion://auth";
    let url: URL = URL(string: "https://api.intra.42.fr/oauth/token")!;
    let oauth: [String: String] = [
        "grant_type": grant_type,
        "client_id": client_id,
        "client_secret": client_secret,
        "code": code,
        "redirect_uri": redirect_uri
    ]
    var json: Dictionary<String, Any> = Dictionary<String, Any>();
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: oauth)
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData;
    
        let (data, response) = try await URLSession.shared.data(for: request);
        var code: Int = 404;
        if let httpResponse = response as? HTTPURLResponse {
            code = httpResponse.statusCode;
        } else {
            return (json);
        }
        if (code != 200) {
            return (json);
        }
        let values: String = String(data: data, encoding: .utf8) ?? "";
        if (values == "") { return (json); }
        json = jsonToDictionary(values);
        return (json);
    } catch { return (json); }
}

class Api {
    static private let baseUrl: String = "https://api.intra.42.fr";
    static private var token: String = "";
    
    public static func setToken(_ tkn: String) -> Void { Api.token = tkn; }

    public static func getValue(_ apiUrl: String) async -> String {
        var jsonString: String = "";
        if (token == "") {
            print("Token not set");
            return (jsonString) ;
        }
        do {
            let url: URL = URL(string: "\(Api.baseUrl)\(apiUrl)")!;
            var request = URLRequest(url: url);
            request.httpMethod = "GET";
            request.setValue("Bearer \(Api.token)", forHTTPHeaderField: "Authorization");
            let (data, response) = try await URLSession.shared.data(for: request);
            var code: Int = 404;
            if let httpResponse = response as? HTTPURLResponse {
                code = httpResponse.statusCode;
            } else {
                return (jsonString);
            }
            if (code != 200) {
                return (jsonString);
            }
            jsonString = String(data: data, encoding: .utf8) ?? "";
            return (jsonString);
        } catch { return (jsonString); }
    }
}
