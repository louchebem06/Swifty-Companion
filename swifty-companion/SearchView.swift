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
    @State private var showAlert = false
    @State private var titleError: String = "";
    @State private var messageError: String = "";
    @State private var isRequestInProgress: Bool = false;
	@State private var disabledButton: Bool = false;
	
	func runSeach() {
		Task() {
			isRequestInProgress = true;
			tmpInput = tmpInput.lowercased();
			tmpInput = tmpInput.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil);
			var value: String = await Api.getValue("/v2/users/\(tmpInput)");
			value = value.replacingOccurrences(of: "validated?", with: "validated", options: .literal, range: nil);
			if (value == "" || tmpInput.isEmpty) {
				titleError = "Invalid login";
				messageError = "'\(tmpInput)' is invalid";
				showAlert = true;
			} else if (value == "Token is not valid") {
				titleError = value;
				messageError = "Token as expired";
				showAlert = true;
			} else {
				do {
					var data: Data = value.data(using: .utf8)!;
					user = try JSONDecoder().decode(User.self, from: data);
					if (user.id != nil) {
						let idUserString: String = String(user.id!);
						value = await Api.getValue("/v2/users/\(idUserString)/coalitions");
						data = value.data(using: .utf8)!;
						user.coalitions = try JSONDecoder().decode([Coalition].self, from: data);
						for n in 0..<user.cursus_users!.count {
							let cursusUsers: CursusUser = user.cursus_users![n]!;
							let idString: String = String(cursusUsers.cursus.id);
							let value = await Api.getValue("/v2/cursus/\(idString)/skills");
							let data: Data = value.data(using: .utf8)!;
							let skills: [SkillItem] = try JSONDecoder().decode([SkillItem].self, from: data);
							skills.forEach({skill in
								var found: Bool = false;
								user.cursus_users![n]!.skills.forEach({sk in
									if (sk.name == skill.name) {
										found = true;
									}
								})
								if (!found) {
									user.cursus_users![n]!.skills.append(Skill(name: skill.name, level: 0.0))
								}
							})
						}
						search = false;
					} else {
						titleError = "User not found";
						messageError = "\(tmpInput) is not valid user 42";
						showAlert = true;
					}
				} catch {
					titleError = "Request error";
					messageError = "Error: \(error)";
					showAlert = true;
				}
			}
			isRequestInProgress = false;
			disabledButton = false;
		}
	}
	
	func runAlert() -> Alert {
		return Alert(
			title: Text(titleError),
			message: Text(messageError)
		)
	}
	
    var body: some View {
        if (search) {
			NavigationStack {
				Image("logo42Nice")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100);
				if isRequestInProgress {
					ProgressView();
				}
			}.searchable(text: $tmpInput)
				.onSubmit(of: .search, runSeach)
				.alert(isPresented: $showAlert) { runAlert() };
        } else {
            IntraView(user);
        }
    }
}
