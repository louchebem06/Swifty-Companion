//
//  SkillView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 04/12/2022.
//

import SwiftUI

struct SkillItems: Identifiable {
	var id = UUID()
	var name: String
	var lvl: Double
}

struct SkillView: View {
	var skills: [SkillItems] = [];
	
	init(_ cursusUser: CursusUser) {
		for skill in cursusUser.skills {
			skills.append(SkillItems(
				name: skill.name,
				lvl: skill.level
			));
		}
	}
	
	var body: some View {
		List(skills) {skill in
			let percent: Double = skill.lvl * 100 / 20 / 100;
			ProgressView(value: percent) {
				Text(skill.name);
			}
		}
	}
}
