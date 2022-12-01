//
//  SearchView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var tmpInput: String = "";
    @State private var search: Bool = true;
    @State private var user: User = User();
    
    var body: some View {
        if (search) {
            VStack {
                TextField(
                    "Search login 42",
                    text: $tmpInput
                ).padding(15);
                Button("Search") {
                    Task {
                        tmpInput = tmpInput.lowercased();
                        let value = await Api.getValue("/v2/users/\(tmpInput)");
                        do {
                            let data = value.data(using: .utf8)!;
                            user = try JSONDecoder().decode(User.self, from: data);
                            if (user.id != nil) {
                                search = false;
                            } else {
                                print("User not found");
                            }
                        } catch {
                            print("Error info: \(error)")
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
