//
//  AchievementView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 06/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AchievementView: View {
	let achievements: [Achievement];
	
	init(_ achievements: [Achievement]) {
		self.achievements = achievements;
	}
	
    var body: some View {
		ScrollView {
			VStack {
				ForEach(achievements, id:\.self.id) { achievement in
					if (achievement.visible ?? false && achievement.image != nil) {
						HStack {
							WebImage(url: URL(string: "https://api.intra.42.fr\(achievement.image!)"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
								.placeholder {ProgressView()}
								.resizable()
								.frame(width: 100, height: 100);
							VStack {
								Text(achievement.name);
								Text(achievement.description);
							}
						}
					}
				}
			}
		}
    }
}
