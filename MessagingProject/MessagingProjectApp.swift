//
//  MessagingProjectApp.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 25.04.2022.
//

import SwiftUI
import Firebase
@main
struct MessagingProjectApp: App {
    init()
    {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
