//
//  GraphView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 01/12/2022.
//

import SwiftUI

struct GraphView: View {
	var cursusUser: CursusUser?;
	let colorCoa: Color;
    
	init(_ cursusUser: [CursusUser?], _ colorCoalition: Color = Color(UIColor.systemBlue)) {
		colorCoa = colorCoalition;
		if (cursusUser.count == 0) {
            self.cursusUser = nil;
        } else {
            self.cursusUser = cursusUser[cursusUser.count - 1];
        }
    }
	
    var body: some View {
		VStack {
			VStack {
				GeometryReader { geometry in
					let level: Double = cursusUser?.level ?? 0.0;
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
                ForEach(0..<nbOfElement, id: \.self) { i in
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
		}.padding(10)
    }
}
