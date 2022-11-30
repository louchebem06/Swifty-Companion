//
//  ProfilView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct ProfilView: View {

    var err: Bool;
    var value: Data;
    
    init(login: String) {
        err = false;
        Task {
            value = try await Api.getValue("/v2/users/\(login.lowercased())").data(using: .utf8)!;
            
        }
        do {
            let newUser: User = try JSONDecoder().decode(User.self, from: value);
            print(newUser);
        } catch {
            print("Error");
            err = true;
        }
    }
    
    var body: some View {
        if (err) {
            Text("User not found");
        } else {
            Text("User Found");
        }
    }
    
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(login: "bledda");
    }
}
