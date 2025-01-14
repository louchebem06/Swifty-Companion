//
//  ProfilView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilView: View {
    
    let user: User;
	let coalition: Coalition;
	let colorCoa: Color;
    
    init(_ user: User) {
        self.user = user;
		self.coalition = user.coalitions![0]!;
		self.colorCoa = hexStringToColor(self.coalition.color);
    }

	var body: some View {
		VStack {
			HStack {
				WebImage(url: coalition.image_url, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
					.placeholder {ProgressView()}
					.resizable()
					.frame(width: 14, height: 14);
				Text(coalition.name)
					.fontWeight(.bold)
					.font(.system(size:14))
					.foregroundColor(colorCoa);
			};
			
			HStack {
				AsyncImage(
					url: user.image?.versions.medium,
					content: { image in
						image.resizable()
							.scaledToFill()
					},
					placeholder: {
						ProgressView()
					}
				).frame(width: 100, height: 100)
					.clipShape(Circle())
					.padding(.leading, 10);
				
				VStack(alignment: .leading) {
					HStack {
						Text("ID: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.id != nil) {
							Text(String(user.id!))
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("LOGIN: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.login != nil) {
							Text(user.login!)
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("FIRST NAME: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.first_name != nil) {
							Text(user.first_name!)
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("LAST NAME: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.last_name != nil) {
							Text(user.last_name!)
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("EMAIL: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.email != nil) {
							Text(user.email!)
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("PHONE: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.phone != nil) {
							Text(user.phone!)
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("WALLET: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.wallet != nil) {
							Text(String(user.wallet!) + "₳")
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
					HStack {
						Text("LOCATION: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						Text(user.location ?? "Unavailable")
							.font(.system(size:12))
							.foregroundColor(.white);
					};
					HStack {
						Text("CORRECTION POINTS: ")
							.fontWeight(.bold)
							.font(.system(size:14))
							.foregroundColor(colorCoa);
						if (user.correction_point != nil) {
							Text(String(user.correction_point!))
								.font(.system(size:12))
								.foregroundColor(.white);
						}
					};
				}.padding(10);
				Spacer()
			}.background(
				AsyncImage(
					url: coalition.cover_url,
					content: { image in
						image.resizable()
							.scaledToFill()
					},
					placeholder: {
						ProgressView()
					}
				)
			)
			.cornerRadius(10)
			.padding(10);
		}
	}
}
