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
    var matrixProblem1: MatrixProblemModel?
    var matrixProblem2: MatrixProblemModel?
    var combo: Int = 0
    var isKeyboard: Bool = true
    var userInput = ""
    var checkAnimation = false
    var inputError: String?
    var success = 0
    var failure = 0
    var updateAlert: Bool = false
    var hapticGenerator: UINotificationFeedbackGenerator? = nil
    var isSuccess1 = false
    var isSuccess2 = false
    var nowProblem: NowProblem = .problem1
    
    var problemTypeString: String {
        var matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        if let problem = matrixproblem {
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
    
    func initGenerate() {
        withAnimation {
            self.matrixProblem1 = MatrixProblemModel.generate()
            self.matrixProblem2 = MatrixProblemModel.generate()
        }
        userInput = ""
        inputError = nil
    }

    // 行列生成時の処理を担当。
    func generate() {
        withAnimation {
            if nowProblem == .problem2 {
                self.matrixProblem1 = MatrixProblemModel.generate()
            } else {
                self.matrixProblem2 = MatrixProblemModel.generate()
            }
        }
        userInput = ""
        inputError = nil
    }

    // 回答確認。それに伴うcomboの更新処理など、一連の処理をまとめる。
    func checkAnswer() async {
        var matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        guard let answer = Int(userInput) else {
            inputError = "数字を入力してください。"
            checkAnimation.toggle()
            return
        }
        
        guard let matrixproblem else {
            preconditionFailure("A problem must be generated before checking an answer.")
        }

        inputError = nil
        let result = matrixproblem.checkAnswer(answer: answer)
        
        if result {
            self.userInput = ""
            if nowProblem == .problem1 {
                self.isSuccess1 = true
            } else {
                self.isSuccess2 = true
            }
//            var player = try? AVAudioPlayer(data: NSDataAsset(name: "determine")!.data)
//            player?.play()
            
            hapticGenerator = UINotificationFeedbackGenerator()
            hapticGenerator?.prepare()
            hapticGenerator?.notificationOccurred(.success)
            hapticGenerator = nil
            
            combo += 1
            success += 1
            
            // TODO: delayを入れる？
            
            Task {
                try? await Task.sleep(nanoseconds: 200000000)
                withAnimation() {
                    self.nowProblem.toggle()
                } completion: {
                    if self.nowProblem == .problem1 {
                        self.isSuccess2 = false
                    } else {
                        self.isSuccess1 = false
                    }
                    self.generate()
                }
            }
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
