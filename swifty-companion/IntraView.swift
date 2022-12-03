//
//  IntraView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct IntraView: View {
	@State private var search: Bool = false
    let user: User;
	let cursusId: Int;
	let colorCoa: Color;
    
    init(_ user: User) {
        self.user = user;
		let cursus_users: [CursusUser?] = user.cursus_users!;
		cursusId = cursus_users[cursus_users.count - 1]!.cursus.id;
		colorCoa = hexStringToColor(user.coalitions![0]!.color);
    }
	
    var body: some View {
		if (search) {
			SearchView()
		} else {
			NavigationView {
				ScrollView {
					VStack {
						ProfilView(user);
						if (user.cursus_users != nil) {
							GraphView(user.cursus_users!, colorCoa);
						}
						if (user.projects_users != nil) {
							ProjectView(user.projects_users!, cursusId);
						}
					}.navigationTitle("Profil")
						.toolbar {
							ToolbarItem(placement: .navigationBarLeading) {
								Button("Back") {
									search = true;
								}
							}
						}
				}
			}
		}
    }
}
