//
//  GraphView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 01/12/2022.
//

import SwiftUI

struct GraphView: View {
    let cursusUser: CursusUser?;
    
    init(_ cursusUser: [CursusUser?]) {
        if (cursusUser.count == 0) {
            self.cursusUser = nil;
        } else {
            self.cursusUser = cursusUser[cursusUser.count - 1];
			Task {
				let cursus: CursusUser = cursusUser[cursusUser.count - 1]!;
				let idString: String = String(cursus.cursus.id);
				let value = await Api.getValue("/v2/cursus/\(idString)/skills");
				// print(value);
			}
        }
    }
    
    var body: some View {
		VStack {
			VStack {
				HStack {
					Text("LEVEL: ");
					Text(String(cursusUser?.level ?? 0.0));
				}
				HStack {
					Text("CURSUS: ");
					Text(cursusUser?.cursus.name ?? "Undefined");
				}
				HStack {
					Text("Grade: ");
					Text(cursusUser?.grade ?? "Undefined");
				}
			};
            VStack {
                let nbOfElement: Int = cursusUser?.skills.count ?? 0;
                ForEach(0..<nbOfElement) { i in
					let name: String = cursusUser!.skills[i].name;
                    let lvl: Double = cursusUser!.skills[i].level;
                    let percent: Double = lvl * 100 / 20 / 100;
                    ProgressView(value: percent) {
                        Text(name);
                    };
                }
                if (nbOfElement == 0) {
                    Text("Skill undefined");
                }
			};
        }
    }
}
