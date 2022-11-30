//
//  ProfilView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct ProfilView: View {
    let token: Dictionary<String, Any>;

    var body: some View {
        Text(token["access_token"] as? String ?? "Empty");
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(token: [:]);
    }
}
