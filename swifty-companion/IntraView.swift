//
//  IntraView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct IntraView: View {
    let user: User;
    
    init(_ user: User) {
        self.user = user;
    }
    var body: some View {
        VStack {
            ProfilView(user);
        }
    }
}

struct IntraView_Previews: PreviewProvider {
    static var previews: some View {
        IntraView(User())
    }
}
