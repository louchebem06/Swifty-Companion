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

func substr(_ string: String, _ start: Int, _ len: Int) -> String {
    var newStr: String = String();
    var i: Int = 0;
    for char in string {
        if (i - start == len) {
            break ;
        }
        if (i < start) {
            i = i + 1;
            continue ;
        }
        newStr.append(char);
        i = i + 1;
    }
    return (newStr);
}

func jsonToDictionary(_ values: String) -> Dictionary<String, Any> {
    var dict: Dictionary<String, Any> = Dictionary();
    let stringNotScope: String = substr(values, 1, values.count - 2);
    let stringSplit: Array<Substring> = stringNotScope.split(separator: ",");
    for string in stringSplit {
        let valueSplit: Array<Substring> = string.split(separator: ":");
        let key: String = substr(String(valueSplit[0]), 1, valueSplit[0].count - 2);
        var value: Any;
        if (valueSplit[1].prefix(1) == "\"") {
            value = substr(String(valueSplit[1]), 1, valueSplit[1].count - 2);
        } else {
            value = Int(valueSplit[1]) ?? -1;
        }
        dict[key] = value;
    }
    return (dict);
}

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
                    if (uri != "auth") { return ; }
                    let query: Dictionary<String, String> = parseQuery(url.query ?? "");
                    let code: String = query["code"] ?? "";
                    if (code == "") { return ; }
                    Task {
                        let token = await codeToToken(UID_42, SECRET_42, code);
                        print(token);
                    }
                }
        }
    }
}
