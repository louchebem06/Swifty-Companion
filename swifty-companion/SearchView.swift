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
    @State private var user: User = User();
    
    var body: some View {
        if (search) {
            VStack {
                TextField(
                    "Search login 42",
                    text: $value
                ).padding(15);
                Button("Search") {
                    Task {
                        // TODO protect value exemple "abc abcd" or "{}"
                        value = value.lowercased();
                        value = await Api.getValue("/v2/users/\(value)");
                        do {
                            let data = value.data(using: .utf8)!;
                            user = try JSONDecoder().decode(User.self, from: data);
                            if (user.id != nil) {
                                search = false;
                            } else {
                                print("User not found");
                            }
                        }
                    }
                }
            }
        } else {
            ProfilView(user: user);
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
