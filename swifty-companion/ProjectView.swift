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

    var body: some View {
		NavigationView {
			List (values) { value in
				HStack {
					Text("\(value.name)");
					if (value.status == "finished") {
						Text((value.validated ?? false) ? "✅" : "❌");
						if (value.validated ?? false) {
							if (value.occurrence == 0) {
								Text("First try");
							} else {
								Text("In \(value.occurrence + 1) try")
							}
						}
						Text("\(String(value.final_mark!))/100");
					} else {
						Text(value.status.replacingOccurrences(of: "_", with: " ").capitalized);
					}
					if (value.child != nil) {
						Text("Subproject: \(String(value.child!.count))")
					}
				}
			}.navigationTitle("Projects");
		}
	}
}
