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
		ScrollView {
			VStack {
				ProfilView(user);
				if (user.cursus_users != nil) {
					GraphView(user.cursus_users!);
				}
				if (user.projects_users != nil) {
					ProjectView(user.projects_users!);
				}
			}
		}
    }
}

struct IntraView_Previews: PreviewProvider {
    static var previews: some View {
        IntraView(User());
    }
}
