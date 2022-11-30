//
//  ProfilView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

struct ProfilView: View {
    
    var user: User;
    
    init(user: User) {
        self.user = user;
        print(user);
    }

    var body: some View {
        VStack {
            Text(String(self.user.id ?? -1));
            Text(self.user.login ?? "Login");
            Text(self.user.first_name ?? "First name");
            Text(self.user.last_name ?? "Last Name");
            Text(self.user.email ?? "email");
            Text(self.user.phone ?? "phone");
            Text(String(self.user.wallet ?? -1));
            Text(self.user.location ?? "location");
        }
    }
    
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView(user: User());
    }
}
