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
	@State private var cursus: CursusUser;
	@State var i: Int = 0;
	@State var refresh: Bool = true;
    
    init(_ user: User) {
		_user = State(initialValue: user);
		let cursus_users: [CursusUser?] = user.cursus_users!;
		_cursus = State(initialValue: cursus_users[0]!);
		colorCoa = hexStringToColor(user.coalitions![0]!.color);
    }
	
	func changeCursus() -> some View {
		return (
			Button {
				refresh = false
				i += 1;
				if (i == user.cursus_users!.count) {
					i = 0;
				}
				cursus = user.cursus_users![i]!;
				refresh = true;
			} label: {
				Label("", systemImage: "arrow.swap");
			}.font(.system(size:20))
				.foregroundColor(colorCoa)
		)
	}
	
	func returnBtm() -> some View {
		return (
			Button {
				search = true;
			}label: {
				Label("", systemImage: "arrowtriangle.backward.fill")
			}.font(.system(size:20))
				.foregroundColor(colorCoa)
		)
	}
	
	@ToolbarContentBuilder
	func getToolBar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			returnBtm();
		}
		ToolbarItem(placement: .principal) {
			CursusView(cursus, colorCoa);
		}
		if (user.cursus_users!.count > 1) {
			ToolbarItem {
				changeCursus();
			}
		}
	}
	
    var body: some View {
		if (search) {
			SearchView()
		} else if (refresh) {
			TabView {
				NavigationView {
					ProfilView(user)
						.toolbar {
							getToolBar();
						};
				}.tabItem {
					Label("Profil", systemImage: "person")
				};
				NavigationView {
					SkillView(cursus)
						.toolbar {
							getToolBar();
						}
						.navigationTitle("Skills");
				}.tabItem {
					Label("Skills", systemImage: "list.dash")
				}
				NavigationView {
					ProjectView(user.projects_users!, cursus.cursus.id)
						.toolbar {
							getToolBar();
						}
						.navigationTitle("Projects");
				}
					.tabItem {
					Label("Projects", systemImage: "square.and.pencil")
				};
			}.accentColor(colorCoa);
		}
    }
}
