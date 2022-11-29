//
//  ContentView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) private var openURL;
    let UID_42: String = ProcessInfo.processInfo.environment["UID_42"] ?? "";
    let SECRET_42: String = ProcessInfo.processInfo.environment["SECRET_42"] ?? "";
    let authUrl: String;

    init () {
        if (UID_42.isEmpty || SECRET_42.isEmpty) {
            print("Env not set");
            exit(1);
        }
        print(UID_42)
        print(SECRET_42);
        let redirect: String = "&redirect_uri=swifty-companion%3A%2F%2Fauth&response_type=code";
        let api42Url: String = "https://api.intra.42.fr";
        authUrl = api42Url + "/oauth/authorize?client_id=" + UID_42 + redirect;
    }
    
    var body: some View {
        Button {
            if let url = URL(string: authUrl) {
                openURL(url);
            }
        } label: {
            Label("Intra 42", systemImage: "terminal")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
