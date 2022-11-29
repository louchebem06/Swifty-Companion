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
        ContentView(authUrl: "")
    }
}
