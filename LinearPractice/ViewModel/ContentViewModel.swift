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
    var matrixProblem: MatrixProblemModel?
    var combo: Int = 0
    var isKeyboard: Bool = true
    var userInput = ""
    var checkAnimation = false
    var inputError: String?
    var success = 0
    var failure = 0
    var updateAlert: Bool = false
    
    var problemTypeString: String {
        if let problem = matrixProblem {
            switch problem.problemType {
            case .add:
                return "行列の足し算"
            case .sub:
                return "行列の引き算"
            case .mul:
                return "行列の掛け算"
            @unknown default:
                return ""
                
            }
        } else {
            return ""
        }
    }
    

    init() {
        combo = UserDefaults.standard.integer(forKey: "combo")
        generate()
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

    // 行列生成時の処理を担当。
    func generate() {
        withAnimation {
            matrixProblem = MatrixProblemModel.generate()
        }
        userInput = ""
        inputError = nil
    }

    // 回答確認。それに伴うcomboの更新処理など、一連の処理をまとめる。
    func checkAnswer() {
        guard let answer = Int(userInput) else {
            inputError = "数字を入力してください。"
            checkAnimation.toggle()
            return
        }
        guard let matrixProblem else {
            preconditionFailure("A problem must be generated before checking an answer.")
        }

        inputError = nil
        let result = matrixProblem.checkAnswer(answer: answer)

        if result {
            combo += 1
            success += 1
            self.generate()           
        } else {
            // GameCenterに送信
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            combo = 0
            failure += 1
            checkAnimation.toggle()
            self.userInput = ""
        }

    }
    
    func doUpdate() {
        self.updateAlert = true
    }
    
    func fromActiveToInactive() {
        GameCenterManager.shared.submitScore(success, to: "com.LinearPractice.keekifami.HighScore")
        GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
        UserDefaults.standard.set(combo, forKey: "combo")
        UserDefaults.standard.set(success, forKey: "success")
        UserDefaults.standard.set(failure, forKey: "failure")
    }

    func storeCombo() {
        UserDefaults.standard.set(combo, forKey: "combo")
    }
}
