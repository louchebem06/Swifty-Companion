//
//  ContentView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) private var openURL;
    let authUrl: String;
    let isLogin: Bool;
    
    var body: some View {
        if (!isLogin) {
            Button {
                if let url = URL(string: authUrl) {
                    openURL(url);
                }
            } label: {
                Label("Intra 42", systemImage: "terminal")
            }
        } else {
            SearchView();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authUrl: "", isLogin: false);
    }
}
