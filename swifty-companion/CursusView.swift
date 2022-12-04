//
//  CursusView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 04/12/2022.
//

import SwiftUI

struct CursusView: View {
	let cursusUser: CursusUser;
	let colorCoa: Color;
	
	init(_ cursusUser: CursusUser, _ colorCoalition: Color) {
		self.cursusUser = cursusUser;
		self.colorCoa = colorCoalition;
	}
	
	var body: some View {
		VStack {
			HStack {
				Text("\(cursusUser.cursus.name) - \(cursusUser.grade ?? "Undefined")")
					.font(.system(size:12))
					.fontWeight(.bold)
					.foregroundColor(colorCoa);
			};
			
				GeometryReader { geometry in
					let level: Double = cursusUser.level;
					let lvl: Int = Int(level)
					let percent: Double = level - Double(lvl);
					ZStack{
						ZStack(alignment: .leading) {
							Rectangle()
								.frame(width: geometry.size.width, height: geometry.size.height + 10)
								.opacity(0.3)
								.foregroundColor(colorCoa);
							
							Rectangle()
								.frame(width: min(CGFloat(percent) * geometry.size.width, geometry.size.width), height: geometry.size.height + 10)
								.foregroundColor(colorCoa);
						}.cornerRadius(45.0);
						
						Text(String("level \(lvl) - \(Int(ceil(percent * 100)))%"))
							.font(.system(size:12))
							.fontWeight(.bold)
							.foregroundColor(Color.white);
					};
				};
			Spacer();
		}.padding(.bottom, 10);
	}
}
