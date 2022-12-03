//
//  swifty_companionApp.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI
import SDWebImageSVGCoder

private extension swifty_companionApp {
	func setUpDependencies() {
		SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
	}
}

@main
struct swifty_companionApp: App {
    private let UID_42: String = ProcessInfo.processInfo.environment["UID_42"]!;
    private let SECRET_42: String = ProcessInfo.processInfo.environment["SECRET_42"]!;
    private var authUrl: URL;
    @State private var isLogin: Bool = false;

    init () {
        Api.setSecret(SECRET_42);
        Api.setUID(UID_42);
        
        authUrl = URL(string: Api.baseUrl)!;
        authUrl.append(path: "/oauth/authorize")
        authUrl.append(queryItems: [
            URLQueryItem(name: "client_id", value: Api.uid),
            URLQueryItem(name: "redirect_uri", value: Api.redirect_uri),
            URLQueryItem(name: "response_type", value: "code")
        ]);
		setUpDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(authUrl, isLogin)
                .onOpenURL { url in
                    let uri: String = url.host!;
                    if (uri == "auth") {
                        let query: Dictionary<String, String> = parseQuery(url.query!);
                        let code: String = query["code"]!;
                        Task {
                            do {
                                _ = await Api.codeToToken(code);
                                isLogin = true;
                            }
                        }
                    }
                }
        }
    }
}
