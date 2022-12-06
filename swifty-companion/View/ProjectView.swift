//
//  ProjectView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct ProjectsItem: Identifiable {
	var id = UUID()
	var id42: Int
	var occurrence: Int
	var name: String
	var final_mark: Int?
	var status: String
	var validated: Bool?
	var parent_id: Int?
	var child: [ProjectsItem]? = nil
}

struct ProjectView: View {
	
	var values: [ProjectsItem] = [];
	
	init(_ projects: [ProjectsUser?], _ cursusId: Int) {
		getMasterProjects(projects, cursusId);
		getChildProjects(projects, cursusId);
	}
	
	func getProjectsItem(_ project: ProjectsUser) -> ProjectsItem {
		return (ProjectsItem(
			id42: project.project.id,
			occurrence: project.occurrence,
			name: project.project.name,
			final_mark: project.final_mark,
			status: project.status,
			validated: project.validated,
			parent_id: project.project.parent_id
		));
	}
	
	mutating func getMasterProjects(_ projects: [ProjectsUser?], _ cursusId: Int) -> Void {
		for project in projects {
			if (project?.project.parent_id != nil) {
				continue ;
			}
			for id in project!.cursus_ids {
				if (id == cursusId) {
					values.append(getProjectsItem(project!));
					break ;
				}
			}
		}
	}
	
	mutating func getChildProjects(_ projects: [ProjectsUser?], _ cursusId: Int) -> Void {
		for project in projects {
			if (project?.project.parent_id == nil) {
				continue ;
			}
			for id in project!.cursus_ids {
				if (id == cursusId) {
					for i in 0..<values.count {
						let item: ProjectsItem = getProjectsItem(project!);
						if (values[i].id42 == item.parent_id) {
							if (values[i].child == nil) {
								values[i].child = [];
							}
							values[i].child!.append(item);
							break ;
						}
					}
					break ;
				}
			}
		}
	}
	
	func getChild(_ childs: [ProjectsItem]) -> some View {
		ForEach(childs) {value in
			HStack {
				Text("\t \(value.name)");
				Spacer();
				if (value.status == "finished") {
					Text((value.validated ?? false) ? "✅" : "❌");
					if (value.final_mark != nil) {
						Text("\(String(value.final_mark!))/100");
					}
				} else {
					Text(value.status.replacingOccurrences(of: "_", with: " ").firstLetterInUpper());
				}
			}
		}
	}

    var body: some View {
		if (values.count == 0) {
			Text("Not project found");
		} else {
			List (values) { value in
				VStack {
					HStack {
						Text("\(value.name)");
						Spacer();
						if (value.status == "finished") {
							Text((value.validated ?? false) ? "✅" : "❌");
							if (value.final_mark != nil) {
								Text("\(String(value.final_mark!))/100");
							}
						} else {
							Text(value.status.replacingOccurrences(of: "_", with: " ").firstLetterInUpper());
						}
					}.fontWeight(.bold);
					if (value.child != nil) {
						VStack {
							getChild(value.child!);
						}.padding(.top, 10);
					}
				}
			}
		}
	}
}

struct ProjectView_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView([], 1);
	}
}
