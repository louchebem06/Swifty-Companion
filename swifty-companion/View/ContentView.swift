//
//  ContentView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) private var openURL;
    let authUrl: URL;
	let isLogin: Bool;
    
    init(_ authUrl: URL, _ isLogin: Bool) {
        self.authUrl = authUrl;
        self.isLogin = isLogin;
    }
    
    var body: some View {
        if (!isLogin) {
            Button {
                openURL(authUrl);
            } label: {
                Label("Login to intra", systemImage: "network")
            }
        } else {
            SearchView();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(URL(string: "http://google.fr")!, false);
    }
}
