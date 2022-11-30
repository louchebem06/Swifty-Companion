//
//  SearchView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var value: String = "";
    @State private var search: Bool = true;
    
    var body: some View {
        if (search) {
            VStack {
                TextField(
                    "Search login 42",
                    text: $value
                ).padding(15);
                Button("Search") {
                    search = false;
                }
            }
        } else {
            ProfilView(login: value);
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
