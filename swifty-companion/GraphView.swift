//
//  GraphView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 01/12/2022.
//

import SwiftUI

struct GraphView: View {
	let cursusUser: CursusUser;
	let colorCoa: Color;
    
	init(_ cursusUser: CursusUser, _ colorCoalition: Color = Color(UIColor.systemBlue)) {
		self.colorCoa = colorCoalition;
		self.cursusUser = cursusUser;
    }
	
    var body: some View {
		VStack {
			HStack {
				Text("\(cursusUser.cursus.name) - \(cursusUser.grade ?? "Undefined")")
					.font(.system(size:12))
					.fontWeight(.bold)
					.foregroundColor(colorCoa);
			};
			
			VStack {
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
			}.padding(.bottom, 40);
			
            VStack {
                let nbOfElement: Int = cursusUser.skills.count;
                ForEach(0..<nbOfElement, id: \.self) { i in
					let name: String = cursusUser.skills[i].name;
                    let lvl: Double = cursusUser.skills[i].level;
                    let percent: Double = lvl * 100 / 20 / 100;
                    ProgressView(value: percent) {
                        Text(name);
                    };
                }
                if (nbOfElement == 0) {
                    Text("Skill undefined");
                }
			};
		}.padding(10)
    }
}
