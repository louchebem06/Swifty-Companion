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
		for project in projects {
			if (project?.project.parent_id != nil) {
				continue ;
			}
			let id = project!.project.id;
			let name = project!.project.name;
			let occurrence = project!.occurrence;
			let final_mark = project?.final_mark;
			let status = project!.status;
			let validated = project?.validated;
			let item = ProjectsItem(
				id42: id,
				occurrence: occurrence,
				name: name,
				final_mark: final_mark,
				status: status,
				validated: validated
			);
			for id in project!.cursus_ids {
				if (id == cursusId) {
					values.append(item);
					break ;
				}
			}
		}
		for project in projects {
			if (project?.project.parent_id == nil) {
				continue ;
			}
			let id = project!.project.id;
			let name = project!.project.name;
			let occurrence = project!.occurrence;
			let final_mark = project?.final_mark;
			let status = project!.status;
			let parent_id = project?.project.parent_id!;
			let validated = project?.validated;
			let item = ProjectsItem(
				id42: id,
				occurrence: occurrence,
				name: name,
				final_mark: final_mark,
				status: status,
				validated: validated,
				parent_id: parent_id
			);
			for id in project!.cursus_ids {
				if (id == cursusId) {
					for i in 0..<values.count {
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
	
	func getChild(_ item: ProjectsItem) -> some View {
		HStack {
			Text("\t - \(item.name)");
			if (item.status == "finished") {
				Text((item.validated ?? false) ? "✅" : "❌");
				Text("\(String(item.final_mark!))/100");
			} else {
				Text(item.status);
			}
			Spacer();
		}
	}
	
	func getItem(_ item: ProjectsItem) -> some View {
		VStack {
			HStack {
				Text("\(item.name)");
				if (item.status == "finished") {
					Text((item.validated ?? false) ? "✅" : "❌");
					if (item.validated ?? false) {
						if (item.occurrence == 0) {
							Text("First try");
						} else {
							Text("In \(item.occurrence + 1) try")
						}
						Text("\(String(item.final_mark!))/100");
					}
				} else {
					Text(item.status.replacingOccurrences(of: "_", with: " ").capitalized);
				}
				Spacer();
			}
			if (item.child != nil) {
				VStack(alignment: .leading) {
					ForEach(item.child!) {currentChild in
						getChild(currentChild);
					}
				}
			}
		}
	}

    var body: some View {
		if (values.isEmpty) {
			Text("Project not found")
		} else {
			VStack(alignment: .leading, spacing: 20) {
				ForEach(values) {value in
					getItem(value);
				}
			}.padding(10);
		}
	}
}
