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
	@State private var disabledSearchBar: Bool = false;
	@State private var msgLoading: String = "";
	
	func getUser() async throws -> User {
		var value: String = await Api.getValue("/v2/users/\(tmpInput)");
		value = value.replacingOccurrences(of: "validated?", with: "validated", options: .literal, range: nil);
		let data: Data = value.data(using: .utf8)!;
		return (try JSONDecoder().decode(User.self, from: data));
	}
	
	func getValues<T: Codable>(_ url: String) async throws -> [T] {
		let value = await Api.getValue(url);
		let data = value.data(using: .utf8)!;
		return (try JSONDecoder().decode([T].self, from: data));
	}
	
	func runSeach() {
		disabledSearchBar = true;
		msgLoading = "Initialisation request";
		Task() {
			isRequestInProgress = true;
			tmpInput = tmpInput.lowercased();
			tmpInput = tmpInput.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil);
			do {
				msgLoading = "Search user";
				user = try await getUser();
				if (user.id != nil) {
					msgLoading = "Information coalitions";
					user.coalitions = try await getValues("/v2/users/\(String(user.id!))/coalitions?coalition[cover]");
					if (user.coalitions != nil && !user.coalitions!.isEmpty) {
						for n in 0..<user.cursus_users!.count {
							msgLoading = "Get empty skill for \(user.cursus_users![n]!.cursus.name)";
							let skills: [SkillItem] = try await getValues("/v2/cursus/\(String(user.cursus_users![n]!.cursus.id))/skills");
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
						msgLoading = "Get locations";
						var page: Int = 1;
						var locations: [Location] = [];
						while (true) {
							let temp: [Location] = try await getValues("/v2/users/\(String(user.id!))/locations?per_page=100&page=\(page)");
							if (temp.isEmpty) {
								break ;
							}
							for tmp in temp {
								locations.append(tmp);
							}
							if (temp.count < 100) {
								break ;
							}
							page += 1;
							msgLoading = "Locations found: \(locations.count)";
						}
						user.locations = locations;
						
						var achievements: [Achievement] = [];
						for campus in user.campus! {
							page = 1;
							while (true) {
								msgLoading = "Get achievements campus \(campus.name) in page \(page)";
								let tmp: [Achievement] = try await getValues("/v2/campus/\(campus.id)/achievements?per_page=100&page=\(page)");
								if (tmp.isEmpty) {
									break ;
								}
								for t in tmp {
									achievements.append(t);
								}
								if (tmp.count < 100) {
									break ;
								}
								page += 1;
							}
						}
						
						var achievementsUser: [AchievementUserItem] = [];
						page = 1;
						while (true) {
							msgLoading = "Get achievements user in page \(page)";
							let tmp: [AchievementUserItem] = try await getValues("/v2/achievements_users?filter[user_id]=\(String(user.id!))&per_page=100&page=\(page)")
							if (tmp.isEmpty) {
								break ;
							}
							for t in tmp {
								achievementsUser.append(t);
							}
							if (tmp.count < 100) {
								break ;
							}
							page += 1;
						}
						
						user.achivements = [];
						for achievementUser in achievementsUser {
							for achievement in achievements {
								if (achievement.id == achievementUser.achievement_id
									&& achievement.nbr_of_success == achievementUser.nbr_of_success)
								{
									user.achivements?.append(achievement);
									break ;
								}
							}
						}

						search = false;
					} else {
						errorNotCoalition();
					}
				} else {
					errorUserNotFound();
				}
			} catch {
				errorRequest(error);
			}
			isRequestInProgress = false;
			disabledSearchBar = false;
			msgLoading = "";
		}
	}
	
	func errorNotCoalition() -> Void {
		titleError = "Error user";
		messageError = "This user as not coalition! realy ?";
		showAlert = true;
	}
	
	func errorUserNotFound() -> Void {
		titleError = "User not found";
		messageError = "\(tmpInput) is not valid user 42";
		showAlert = true;
	}
	
	func errorRequest(_ error: any Error) -> Void {
		titleError = "Request error";
		messageError = "Error: \(error)";
		showAlert = true;
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
					.frame(width: 100, height: 100)
						.navigationTitle("Search user 42");
				if isRequestInProgress {
					ProgressView(msgLoading);
				}
			}.searchable(text: $tmpInput)
				.onSubmit(of: .search, runSeach)
				.alert(isPresented: $showAlert) { runAlert() }
				.disabled(disabledSearchBar);
        } else {
            IntraView(user);
        }
    }
}
