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
			VStack(alignment: .leading) {
				ForEach(achievements, id:\.self.id) { achievement in
					if (achievement.visible ?? false && achievement.image != nil) {
						HStack {
							WebImage(url: URL(string: "https://api.intra.42.fr\(achievement.image!)"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
								.placeholder {
									ProgressView()
								}
								.resizable()
								.frame(width: 50, height: 50);
							VStack (alignment: .leading) {
								HStack {
									Text(achievement.name);
									if (achievement.nbr_of_success != nil) {
										Text(String(achievement.nbr_of_success!));
									}
								}.fontWeight(.bold)
									.font(.system(size: 14));
								Text(achievement.description)
									.font(.system(size: 12));
							}
						}
					}
				}
			}
		}.padding(10);
    }
}

struct AchievementView_Previews: PreviewProvider {
	static var previews: some View {
		AchievementView([
			Achievement(
				id: 46,
				name: "Achievement Title",
				description: "Description achievement",
				visible: Optional(true),
				image: "/uploads/achievement/image/46/PED005.svg",
				nbr_of_success: 12
			)
		]);
	}
}
