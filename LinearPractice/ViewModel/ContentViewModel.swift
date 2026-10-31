//
//  ContentViewModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/13
//  
//

import SwiftUI
import AVFoundation

enum NowProblem {
    case problem1
    case problem2
    
    mutating func toggle() {
        if self == .problem1 {
            self = .problem2
        } else {
            self = .problem1
        }
    }
}

@Observable
class ContentViewModel {
    var success = 0
    var failure = 0
    var combo: Int = 0
    var isKeyboard: Bool = true
    var userInput = ""
    
    // ContentViewModel+GenerateProblem
    var matrixProblem1: MatrixProblemModel?
    var matrixProblem2: MatrixProblemModel?
    var checkAnimation = false
    var isSuccess1 = false
    var isSuccess2 = false
    var nowProblem: NowProblem = .problem1
    var updateAlert: Bool = false
    
    // ContentViewModel+CheckAnswer
    var isBubbleAnimation: Bool = false
    var hapticGenerator: UINotificationFeedbackGenerator? = nil
    let achievementSet: Set<Int> = [10, 50, 77, 100, 200, 500, 777, 1000]

    init() {
        combo = UserDefaults.standard.integer(forKey: "combo")
        self.initGenerate()
    }
    
    func appear() {
        combo = UserDefaults.standard.integer(forKey: "combo")
        success = UserDefaults.standard.integer(forKey: "success")
        failure = UserDefaults.standard.integer(forKey: "failure")
    }
    
    // メモ/pad切り替えボタンの処理を担当
    func togglePadView() {
        isKeyboard.toggle()
    }

    func fromActiveToInactive() {
        GameCenterManager.shared.submitScore(success, to: "com.LinearPractice.keekifami.HighScore")
        GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
        UserDefaults.standard.set(combo, forKey: "combo")
        UserDefaults.standard.set(success, forKey: "success")
        UserDefaults.standard.set(failure, forKey: "failure")
    }
}
