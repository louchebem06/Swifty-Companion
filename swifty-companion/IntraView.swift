//
//  IntraView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct IntraView: View {
	@State private var search: Bool = false
    @State private var user: User;
	let colorCoa: Color;
	@State private var title: String;
	@State private var cursus: CursusUser;
	@State var i: Int = 0;
	@State var refresh: Bool = true;
    
    init(_ user: User) {
		_user = State(initialValue: user);
		let cursus_users: [CursusUser?] = user.cursus_users!;
		_cursus = State(initialValue: cursus_users[0]!);
		colorCoa = hexStringToColor(user.coalitions![0]!.color);
		_title = State(initialValue: "\(user.first_name!) \(user.last_name!)");
    }
	
    var body: some View {
		if (search) {
			SearchView()
		} else if (refresh) {
			NavigationView {
				ScrollView {
					VStack {
						ProfilView(user);
						if (user.cursus_users!.count > 1) {
							Button("Change Cursus") {
								refresh = false
								i += 1;
								if (i == user.cursus_users!.count) {
									i = 0;
								}
								cursus = user.cursus_users![i]!;
								refresh = true;
							}.fontWeight(.bold)
								.font(.system(size:14))
								.foregroundColor(colorCoa);
						}
						GraphView(cursus, colorCoa);
						ProjectView(user.projects_users!, cursus.cursus.id);
					}.navigationTitle(title)
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
