//
//  ContentViewModel+Update.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/28
//  
//

// MARK: アップデート確認用
extension ContentViewModel {
    var updateAlert: Bool = false
    
    func doUpdate() {
        self.updateAlert = true
    }
    
}
