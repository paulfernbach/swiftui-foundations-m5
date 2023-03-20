//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/20/23.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
