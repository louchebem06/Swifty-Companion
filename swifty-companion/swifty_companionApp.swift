//
//  swifty_companionApp.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

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
        }
    }
}
