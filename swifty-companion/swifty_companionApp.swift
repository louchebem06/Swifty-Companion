//
//  swifty_companionApp.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

func parseQuery(_ queryString: String) -> Dictionary<String, String> {
    var query: Dictionary<String, String> = Dictionary();
    let values: Array<Substring> = queryString.split(separator: "&");
    for value in values {
        let valueQuery: Array<Substring> = value.split(separator: "=");
        query[String(valueQuery[0])] = String(valueQuery[1]);
    }
    return (query);
}

func codeToToken(_ client_id: String,_ client_secret: String,_ code: String) -> Void {
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
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: oauth)
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData;
    
        let action = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    return
                }
                print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
        };
        action.resume();
    } catch { return ; }
}

@main
struct swifty_companionApp: App {
    let UID_42: String = ProcessInfo.processInfo.environment["UID_42"] ?? "";
    let SECRET_42: String = ProcessInfo.processInfo.environment["SECRET_42"] ?? "";
    let authUrl: String;

    init () {
        if (UID_42.isEmpty || SECRET_42.isEmpty) {
            print("Env not set");
            exit(1);
        }
        let api42Url: String = "https://api.intra.42.fr";
        let redirect: String = "&redirect_uri=swifty-companion%3A%2F%2Fauth&response_type=code";
        authUrl = api42Url + "/oauth/authorize?client_id=" + UID_42 + redirect;
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(authUrl: authUrl)
                .onOpenURL { url in
                    let uri: String = url.host ?? "";
                    if (uri == "auth") {
                        let query: Dictionary<String, String> = parseQuery(url.query ?? "");
                        let code: String = query["code"] ?? "";
                        if (code == "") { return ; }
                        codeToToken(UID_42, SECRET_42, code);
                    }
                }
        }
    }
}
