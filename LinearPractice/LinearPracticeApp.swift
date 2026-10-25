//
//  LinearPracticeApp.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/23.
//

import SwiftUI

@main
struct LinearPracticeApp: App {
    @AppStorage("initialLaunch") var initialLaunch: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                if initialLaunch == false {
                    OnboardingView()
                }
            }
        }
    }
}
