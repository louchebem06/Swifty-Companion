//
//  ProjectView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct ProjectView: View {
	var projectsDictionary: Dictionary<Int, [ProjectsUser]> = Dictionary<Int, [ProjectsUser]>();
	let cursusId: Int;
	
	init(_ projects: [ProjectsUser?], _ cursusId: Int) {
		self.cursusId = cursusId;
		if (projects.count != 0) {
			createDictionary(projects);
		}
	}
	
	mutating func createDictionary(_ projects: [ProjectsUser?]) {
		for project in projects {
			let id: Int = project!.project.id;
			let parent_id: Int? = project?.project.parent_id;
			let cursus_ids: [Int] = project!.cursus_ids;
			var isGoodCursus: Bool = false;
			cursus_ids.forEach({id in
				if (id == cursusId) {
					isGoodCursus = true;
				}
			})
			if (isGoodCursus) {
				if (parent_id == nil) {
					if (projectsDictionary[id] == nil) {
						projectsDictionary[id] = [project!]
					} else {
						projectsDictionary[id]!.append(project!)
					}
				} else {
					if (projectsDictionary[parent_id!] == nil) {
						projectsDictionary[parent_id!] = [project!]
					} else {
						projectsDictionary[parent_id!]!.append(project!)
					}
				}
			}
		}
	}
	
	func getProject(_ project: ProjectsUser) -> some View {
		return (
			VStack {
				Text("\(project.project.name) \(project.occurrence)");
			}
		)
	}
	
	func getProjects(_ index: Int) -> some View {
		var i = 0;
		var values: [ProjectsUser] = [ProjectsUser]();

		projectsDictionary.forEach({k, v in
			if (i == index) {
				values = v;
			}
			i += 1;
		})
		return (
			VStack {
				ForEach(0..<values.count, id: \.self) {index in
					getProject(values[index]);
				}
				Text("");
			}
		)
	}

    var body: some View {
		if (projectsDictionary.isEmpty) {
			Text("Project not found")
		} else {
			ForEach(0..<projectsDictionary.count, id: \.self) {index in
				getProjects(index)
			}
		}
    }
}
