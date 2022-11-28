//
//  swifty_companionApp.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 28/11/2022.
//

import SwiftUI

@main
struct swifty_companionApp: App {
    init () {
        let UID_42: String = ProcessInfo.processInfo.environment["UID_42"] ?? "";
        let SECRET_42: String = ProcessInfo.processInfo.environment["SECRET_42"] ?? "";
        if (UID_42.isEmpty || SECRET_42.isEmpty) {
            print("Env not set");
            exit(1);
        }
        print(UID_42)
        print(SECRET_42);
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
