//
//  ContentViewModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/13
//  
//

import SwiftUI

@Observable
class ContentViewModel {
    var combo: Int = 0
    var isKeyboard: Bool = true
    
    func appear() {
        combo = UserDefaults.standard.integer(forKey: "combo")
    }
    
    func togglePadView() {
        isKeyboard.toggle()
    }
}
