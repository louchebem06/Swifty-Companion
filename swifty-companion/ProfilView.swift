//
//  ProfilView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct ProfilView: View {
    
    var user: User;
    
    init(_ user: User) {
        self.user = user;
    }

    var body: some View {
        HStack(alignment: .top) {
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
                .padding(10);

            VStack(alignment: .leading) {
                HStack {
                    Text("ID: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.id != nil) {
                        Text(String(user.id!))
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("LOGIN: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.login != nil) {
                        Text(user.login!)
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("FIRST NAME: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.first_name != nil) {
                        Text(user.first_name!)
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("LAST NAME: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.last_name != nil) {
                        Text(user.last_name!)
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("EMAIL: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.email != nil) {
                        Text(user.email!)
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("PHONE: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.phone != nil) {
                        Text(user.phone!)
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("WALLET: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.wallet != nil) {
                        Text(String(user.wallet!) + "₳")
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
                HStack {
                    Text("LOCATION: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    Text(user.location ?? "Unavailable")
                        .font(.system(size:12))
                        .foregroundColor(.white);
                };
                HStack {
                    Text("CORRECTION POINTS: ")
                        .fontWeight(.bold)
                        .font(.system(size:14));
                    if (user.correction_point != nil) {
                        Text(String(user.correction_point!))
                            .font(.system(size:12))
                            .foregroundColor(.white);
                    }
                };
            }.padding(10);
        }
        .background(Color.purple.opacity(0.9))
        .cornerRadius(10);
        // TODO add background coa https://api.intra.42.fr/apidoc/2.0/coalitions/index.html or color
        // .background(AsyncImage(url: user.image?.versions.medium));
    }
    
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(User());
    }
}
