//
//  ProjectView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 02/12/2022.
//

import SwiftUI

struct ProjectView: View {
	let projects: [ProjectsUser?];
	let projectFound: Bool;
	
	init(_ projects: [ProjectsUser?]) {
		self.projects = projects;
		if (projects.count == 0) {
			projectFound = false;
		} else {
			projectFound = true;
		}
	}
	
	func getColor(_ color: String) -> Color {
		switch(color) {
		case "finished":
			return (Color.red);
		default:
			return (Color.green);
		}
	}
	
    var body: some View {
		VStack {
			if (!projectFound) {
				Text("Project not found")
			} else {
				ForEach (0..<projects.count) {i in
					let occurrence: Int = projects[i]!.occurrence;
					let final_mark: Int? = projects[i]!.final_mark;
					let status: String = projects[i]!.status;
					let validated: Bool? = projects[i]!.validated;
					let name: String = projects[i]!.project.name;
					let marked: Bool = projects[i]!.marked;
					var color: Color = getColor(status);
					VStack {
						Text(String(occurrence));
						if (final_mark != nil) {
							Text(String(final_mark!));
						}
						Text(status);
						if (validated != nil) {
							Text(String(validated!));
						}
						Text(name);
						Text(String(marked));
					}.background(color)
						.padding(10);
				}
			}
		}
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView([])
    }
}
